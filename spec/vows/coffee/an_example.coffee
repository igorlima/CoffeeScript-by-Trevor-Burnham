async   = require 'async'
vows    = require 'vows'
assert  = require 'assert'
config  = require '../../lib/sauce-conf.js'
browser = config.browser

#Create a Test Suite
vows.describe('An example')
.addBatch(
  'Opening the page':
    topic: ->
      async.waterfall [
        (callback) -> browser.init config.desired, -> callback null
        (callback) ->
          browser.get "http://saucelabs.com/test/guinea-pig", -> callback null
      ], (err, result) => @callback null, result
      return
    'Page title':
      topic: -> browser.title (err, title) => @callback err, title
      "The page title should be 'I am a page title - Sauce Labs'": (title) ->
        assert.ok title.indexOf('I am a page title - Sauce Labs') >= 0
).addBatch(
  'Exiting the browser':
    topic: ->
      browser.quit @callback
      return
    'The end': ->
).export module
