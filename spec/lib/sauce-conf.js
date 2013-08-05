var webdriver = require('wd'),
    Q         = require("q"),
    request   = require("request"),
    async     = require('async'),
    argv      = require('optimist').argv,
    exports   = module.exports = {},
    host      = "ondemand.saucelabs.com",
    port      = 80,
    username  = process.env.SAUCE_USERNAME,
    accessKey = process.env.SAUCE_ACCESS_KEY,
    browser = exports.browser = webdriver.remote(host, port, username, accessKey),

    desired = exports.desired = {
      "browserName": argv.browserNameSL || "chrome",
      "version"    : argv.versionSL     || "",
      "platform"   : argv.platformSL    || "Linux",
      "tags"       : ["Scrabble", "test"],
      "name"       : "Scrabble tests",
      "public"     : "public",
      "build"      : process.env.TRAVIS_BUILD_NUMBER || "dev-tests",
      "tunnel-identifier": process.env.TRAVIS_JOB_NUMBER || "Scrabble",
      "record-video": true
    },

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

    waitUntilResultsAreAvailable = function(js, timeout, start, callback) {
      var now = new Date();
      start = start || now;

      if (now - start > timeout) {
        callback( new Error("Timeout: Element not there") );
      } else {
        browser.eval(js, function(err, jsValue) {
          if (jsValue !== null) callback(null, {resultScript: jsValue});
          else waitUntilResultsAreAvailable(js, timeout, start, callback);
        });
      }
    };

exports.updateJobStatus = function(script, callback) {
  async.waterfall([

    function(callback) {
      waitUntilResultsAreAvailable(script, 15000, null, callback);
    },

    function(obj, callback) {
      var data = resultScript = obj.resultScript;
      data.passed = resultScript.passed || resultScript.failedCount === 0;

      api(["/v1/", username, "/jobs/", browser.sessionID].join(""), "PUT", data)
        .then(function(body) {
          obj.body = body;
          console.warn("Check out test results at http://saucelabs.com/jobs/" + browser.sessionID + "\n");
          callback(null, obj);
        });
    }
  ], function(err, result) {
    callback(err, result);
  });
};

browser.on("status", function(info) {
  //console.log("\x1b[36m%s\x1b[0m", info);
});

browser.on("command", function(meth, path, data) {
  //console.log(" > \x1b[33m%s\x1b[0m: %s", meth, path, data || "");
});

/**
Vows Errored » callback not fired
http://birkett.no/blog/2013/05/01/vows-errored-callback-not-fired/
*/
process.on('uncaughtException', function(err) {
  browser.quit();
  console.error('Caught exception: ' + err.stack );
});
