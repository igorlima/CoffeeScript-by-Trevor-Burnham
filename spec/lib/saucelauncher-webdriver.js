/**
 * JavaScript tests integration with Sauce
 * https://saucelabs.com/docs/javascript-unit-tests-integration
 */
var config  = require('./sauce-conf.js'),
    Q       = require("q"),
    request = require("request"),
    $       = require('jquery'),
    async   = require('async'),
    username = process.env.SAUCE_USERNAME,
    accessKey = process.env.SAUCE_ACCESS_KEY,
    browser = config.browser,
    desired = {};

$.extend(desired, config.desired, {
  "browserName": process.argv[2],
  "version"    : process.argv[3],
  "platform"   : process.argv[4]
});

// general rest call helper function using promises
var api = function (url, method, data) {
  var deferred = Q.defer();
  request({
    method: method,
    uri: ["https://", username, ":", accessKey, "@saucelabs.com/rest", url].join(""),
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(data)
  }, function (error, response, body) {
    deferred.resolve(response.body);
  });
  return deferred.promise;
};

function waitUntilResultsAreAvailable(js, timeout, start, callback) {
  var now = new Date();
  start = start || now;

  if (now - start > timeout) {
    callback( new Error("Timeout: Element not there") );
  } else {
    browser.eval(js, function(err, jsValue) {
      jsValue !== null ? callback(null, jsValue) : waitUntilResultsAreAvailable(js, timeout, start, callback);
    });
  }
}

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
    var script = "jasmine.currentEnv_.currentRunner_.results().failedCount";
    waitUntilResultsAreAvailable(script, 15000, null, callback);
  },

  function(failedCount, callback) {
    var data = {
      "passed": failedCount === 0
    };

    api(["/v1/", username, "/jobs/", browser.sessionID].join(""), "PUT", data)
      .then(function(body) {
        callback(null, body);
      });
  },

  function(body, callback) {
    console.log("CONGRATS - WE'RE DONE\n", "Check out test results at http://saucelabs.com/jobs/" + browser.sessionID + "\n");
    //console.log(body);
    callback(null);
  }

], function(err) {
  err && console.log('Caught exception: ' + err);
  browser.quit();
});
