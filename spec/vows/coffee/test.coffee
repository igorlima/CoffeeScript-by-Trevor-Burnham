async  = require 'async'
vows   = require 'vows'
assert = require 'assert'
config = require '../lib/sauce-conf.js'

#Create a Test Suite
vows.describe('An example').addBatch(
  'Sauce Labs page':
    topic: config.browser
    'Check page title': (browser) ->
      async.waterfall [
        (callback) ->
          browser.get "http://saucelabs.com/test/guinea-pig", callback
        (callback) ->
          browser.title (err, title) -> callback err, title
        (title, callback) ->
          assert.ok title.indexOf('I am a page title - Sauce Labs'), 'Wrong title!'
          browser.elementById 'submit', (err, element) -> callback err, element
        (element, callback) ->
          browser.clickElement element, callback
        (callback) ->
          browser.eval "window.location.href", (err, href) -> callback err, href
        (href, callback) ->
          assert.ok href.indexOf('guinea'), 'Wrong URL!'
      ], (err, result) ->
        console.log err
        browser.quit()

).export module
