var webdriver = require('wd'),
    async     = require('async'),
    argv      = require('optimist').argv,
    exports   = module.exports = {},

    libraryName = exports.libraryName = "Scrabble",

    auth      = exports.browser = {
      username:  process.env.SAUCE_USERNAME,
      accessKey: process.env.SAUCE_ACCESS_KEY,
      build:     process.env.TRAVIS_BUILD_NUMBER || "dev-tests",
      tunnelIdentifier: process.env.TRAVIS_JOB_NUMBER || libraryName
    },

    host      = "ondemand.saucelabs.com",
    port      = 80,
    browser = exports.browser = webdriver.remote(host, port, auth.username, auth.accessKey),

    desired = exports.desired = {
      "browserName": argv.browserNameSL || "chrome",
      "version"    : argv.versionSL     || "",
      "platform"   : argv.platformSL    || "Linux",
      "tags"       : [libraryName, "test"],
      "name"       : libraryName + " tests",
      "public"     : "public",
      "build"      : auth.build,
      "tunnel-identifier": auth.tunnelIdentifier,
      "record-video": true
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
