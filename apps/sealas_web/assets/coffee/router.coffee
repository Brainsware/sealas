Vue       = require 'vue'
VueRouter = require 'vue-router'

Vue.use VueRouter

router = new VueRouter
  mode: 'history'
  routes: [
    #{ path: '*', component: NotFound },
    { path: '/', component: '' },
    { path: '*/login', component: require './pages/login' },
  ]

router.beforeEach (to, from, next) ->
  if _paq?
    _paq.push(['setCustomUrl', to.fullPath])
    _paq.push(['setReferrerUrl', from.fullPath])
    #_paq.push(['setDocumentTitle', 'My New Title'])
    _paq.push(['setGenerationTimeMs', 0])
    _paq.push(['trackPageView'])

  next()

module.exports = router
