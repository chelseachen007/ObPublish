#!/usr/bin/env bash
#
# Vercel 构建前置：把 content 子模块拉下来。
#
# 背景：content 子模块（Obsidian 库）只是被 quartz 当纯文本目录读取，
# 完全不需要 git 历史。全量 clone 那个仓库在 Vercel 上很容易被网络抖动搞挂，
# 所以这里默认走 partial clone（--filter=blob:none）+ 重试，失败时再退回全量。
#
# 可用环境变量：
#   GITHUB_REPO_CLONE_TOKEN  私有子模块需要的 GitHub token；仓库公开时可留空
#   SUBMODULE_FULL_CLONE=1   强制全量克隆（排查用）
#   SUBMODULE_RETRIES=3      重试次数，默认 3
#
set -Eeuo pipefail

GITMODULES=".gitmodules"
FEXT=".bak"
GITMODULES_BACKUP="${GITMODULES}${FEXT}"
RETRIES="${SUBMODULE_RETRIES:-3}"

log() { echo "[submodule] $*"; }

cleanup() {
  log "restoring .gitmodules..."
  rm -f "$GITMODULES" "$GITMODULES_BACKUP"
  git restore "$GITMODULES" 2>/dev/null || true
}
trap cleanup EXIT

# 带退避的重试：失败不立刻退出，留给下一轮
retry() {
  local desc="$1"
  shift
  local n=1
  until "$@"; do
    if [ "$n" -ge "$RETRIES" ]; then
      log "✗ ${desc} 失败（已重试 ${RETRIES} 次）"
      return 1
    fi
    local wait=$((n * 5))
    log "… ${desc} 失败，${wait}s 后重试（${n}/${RETRIES}）"
    sleep "$wait"
    n=$((n + 1))
  done
}

submodule_workaround() {
  local paths
  # 构建环境里的全局 url.insteadOf 改写（比如 oauth2:dummy）会把 https 地址
  # 改成带假凭证的地址，匿名拉取直接 401，这里先暴露出来方便排查
  if git config --get-regexp '^url\..*\.insteadof$' >/dev/null 2>&1; then
    log "⚠ 检测到全局 url.insteadOf 改写，可能影响子模块拉取："
    git config --get-regexp '^url\..*\.insteadof$' | sed 's/^/    /'
  fi

  if [ -n "${GITHUB_REPO_CLONE_TOKEN:-}" ]; then
    # 和旧脚本保持一致：把 token 注入 .gitmodules（现在的子模块是 https 地址，
    # 这一步其实是空操作，留着是为了将来换回 ssh 地址时还能用）
    export GIT_TERMINAL_PROMPT=0
    log "注入 token 到 .gitmodules..."
    sed -i"$FEXT" "s|git@github.com:|https://oauth2:${GITHUB_REPO_CLONE_TOKEN}@github.com/|" "$GITMODULES"
  else
    # 仓库是公开的，没有 token 也能拉；以前这里直接 exit 1 会白白挡掉构建
    log "GITHUB_REPO_CLONE_TOKEN 为空，按公开仓库继续"
  fi

  log "同步子模块远端配置..."
  git submodule sync --recursive

  log "清理残留子模块目录..."
  git config --file .gitmodules --get-regexp path | awk '{print $2}' | xargs -r rm -rf

  paths="$(git config --file .gitmodules --get-regexp path | awk '{print $2}')"
  [ -n "$paths" ] || { log "没有子模块，跳过"; return 0; }

  if [ "${SUBMODULE_FULL_CLONE:-0}" == "1" ]; then
    log "更新子模块（全量）：$(echo $paths)"
    retry "submodule fetch" git submodule update --init --recursive --jobs "$(getconf _NPROCESSORS_ONLN)" \
      || { log "✗ 全量拉取失败，构建中止"; return 1; }
  else
    # 逐个处理：每个子模块自己决定要哪个 commit，partial clone 才有意义
    for p in $paths; do
      local sha
      sha="$(git ls-tree HEAD "$p" | awk '{print $3}')"
      log "拉取 $p @ ${sha:0:10}（partial clone）..."
      retry "fetch $p" git -c protocol.version=2 clone \
        --filter=blob:none --no-checkout --depth 1 \
        --no-single-branch "$(git config --file .gitmodules --get "submodule.$p.url")" "$p" \
        || {
          log "partial clone 失败，退回全量拉取 $p"
          retry "full fetch $p" git submodule update --init --recursive -- "$p" \
            || { log "✗ $p 拉取失败（partial 与全量都没成功），构建中止"; return 1; }
        }

      retry "checkout $p" git -C "$p" fetch --filter=blob:none origin "$sha" \
        || { log "按 sha 直取失败，退回 origin/HEAD"; git -C "$p" fetch --filter=blob:none origin; }
      git -C "$p" -c advice.detachedHead=false checkout --force --quiet "$sha" 2>/dev/null || {
        log "checkout $sha 失败，改用 origin/HEAD"
        git -C "$p" -c advice.detachedHead=false checkout --force --quiet "$(git -C "$p" rev-parse origin/HEAD)" 2>/dev/null
      }
      log "✓ $p 就位（$(git -C "$p" rev-parse --short HEAD 2>/dev/null || echo "?")）"
    done
  fi

  verify_submodules
}

# 校验每个子模块都和 superproject 记录的 commit 对齐；不对齐就重拉一次，还不行就明确失败
verify_submodules() {
  local bad=0 p want got only="${1:-}"
  local targets
  targets="$(git config --file .gitmodules --get-regexp path | awk '{print $2}')"
  [ -n "$only" ] && targets="$only"
  for p in $targets; do
    want="$(git ls-tree HEAD "$p" | awk '{print $3}')"
    # 目录被删/没检出时 -C 会失败，用 || true 兜住，别让 set -e 把脚本钉死
    got="$(git -C "$p" rev-parse HEAD 2>/dev/null || true)"
    if [ "$want" != "$got" ]; then
      log "⚠ $p 当前 ${got:0:10}，期望 ${want:0:10}，重拉一次"
      rm -rf "$p" ".git/modules/$p"
      retry "re-fetch $p" git submodule update --init --recursive -- "$p" || bad=1
      got="$(git -C "$p" rev-parse HEAD 2>/dev/null || true)"
      [ "$want" == "$got" ] || { log "✗ $p 仍然是 ${got:0:10}"; bad=1; }
    else
      log "✓ $p 对齐 ${got:0:10}"
    fi
  done

  [ "$bad" == "0" ] || { log "✗ 子模块校验失败，构建中止"; return 1; }
  log "✓ 子模块校验通过"
}

submodule_workaround
