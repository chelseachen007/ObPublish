import { QuartzComponentConstructor } from "./types"

export default (() => {
  function Footer() {
    return (
      <script
        src="https://giscus.app/client.js"
        data-repo="chelseachen007/ObPublish"
        data-repo-id="R_kgDOJSeHfQ"
        data-category="General"
        data-category-id="DIC_kwDOJSeHfc4CXVcx"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="preferred_color_scheme"
        data-lang="zh-CN"
        data-loading="lazy"
        crossorigin="anonymous"
        async
      ></script>
    )
  }

  return Footer
}) satisfies QuartzComponentConstructor
