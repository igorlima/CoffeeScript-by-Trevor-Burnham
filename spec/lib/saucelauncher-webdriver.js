/**
 * JavaScript tests integration with Sauce
 * https://saucelabs.com/docs/javascript-unit-tests-integration
 */
var config  = require('./sauce-conf.js'),
    async   = require('async'),
    username = process.env.SAUCE_USERNAME,
    accessKey = process.env.SAUCE_ACCESS_KEY,
    browser = config.browser,
    desired = config.desired;

async.waterfall([

  function(callback) {
    browser.init(desired, function(){
      callback(null);
    });
  },

  function(callback) {
    browser.get("http://localhost:8080", function(){
      callback(null);
    });
  },

  function(callback) {
    config.updateJobStatus("{failedCount: jasmine.currentEnv_.currentRunner_.results().failedCount}", callback);
  },

  function(result, callback) {
    browser.quit(function(err){
      callback(err);
    });
  }

], function(err) {
  err && console.error('Caught exception: ' + err.stack);
});
