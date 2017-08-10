console.log '%cStop!', 'color: red; font-size: 30pt; background-color: black; padding: 2px 20px'
console.log '%cThis is the developers console, please don\'t try and enter something here if you don\'t know what you are doing', 'font-size: 14pt'

Vue    = require 'vue'
routes = require './router'

app = new Vue(
  router: router
  el: '#app'

  render: (h) -> h require('./init.vue')
)
