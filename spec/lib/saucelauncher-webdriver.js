/**
 * JavaScript tests integration with Sauce
 * https://saucelabs.com/docs/javascript-unit-tests-integration
 */
var config  = require('./sauce-conf.js'),
    Q       = require("q"),
    request = require("request"),
    $       = require('jquery'),
    username = process.env.SAUCE_USERNAME,
    accessKey = process.env.SAUCE_ACCESS_KEY,
    browser = config.promiseBrowser,
    desired = {},

    // general rest call helper function using promises
    api = function (url, method, data) {
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
    },

    waitUntilResultsAreAvailable = function(js, timeout, start) {
      var now = new Date();
      start = start || now;

      if (now - start > timeout)
        throw new Error("Timeout: Element not there");

      return browser.eval(js)
        .then(function (jsValue) {
          if (jsValue !== null) { return jsValue; }
          else { return waitUntilResultsAreAvailable(js, timeout, start); }
        });
    };

$.extend(desired, config.desired, {
  "browserName": process.argv[2],
  "version"    : process.argv[3],
  "platform"   : process.argv[4]
});

// test case
browser.init(desired).then(function () {
  return browser.get("http://localhost:8080");
}).then(function () {
  var script = "jasmine.currentEnv_.currentRunner_.results().failedCount";
  return waitUntilResultsAreAvailable(script, 5000);
}).then(function (failedCount) {
  var data = {
    "passed": failedCount === 0
  };
  return api(["/v1/", username, "/jobs/", browser.sessionID].join(""), "PUT", data);
}).then(function (body) {
  console.warn("Check out test results at http://saucelabs.com/jobs/" + browser.sessionID + "\n");
  //console.log(body);
}).fin(function () {
  return browser.quit();
}).done();

process.exit();
