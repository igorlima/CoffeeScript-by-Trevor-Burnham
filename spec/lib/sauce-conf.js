var webdriver = require('wd'),
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

    info = function(info) {
      //console.log("\x1b[36m%s\x1b[0m", info);
    },

    command = function(meth, path, data) {
      //console.log(" > \x1b[33m%s\x1b[0m: %s", meth, path, data || "");
    };

browser.on("status", info);
browser.on("command", command);

/**
Vows Errored » callback not fired
http://birkett.no/blog/2013/05/01/vows-errored-callback-not-fired/
*/
process.on('uncaughtException', function(err) {
  browser.quit();
  console.error('Caught exception: ' + err.stack );
});
