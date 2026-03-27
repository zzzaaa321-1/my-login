const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  lintOnSave: false, // 禁用ESLint检查
  devServer: {
    port: 8080,
    proxy: {
      '/api': {
        target: 'http://localhost:8081',
        changeOrigin: true,
        pathRewrite: {
          '^/api': '/api'
        }
      }
    }
  },
  css: {
    loaderOptions: {
      sass: {
        additionalData: `@import "@/assets/css/variables.scss";`
      }
    }
  }
})
