var webdriver = require('wd'),
    exports = module.exports = {},
    host = "ondemand.saucelabs.com",
    port = 80,
    username = process.env.SAUCE_USERNAME,
    accessKey = process.env.SAUCE_ACCESS_KEY,
    browser = exports.browser = webdriver.remote(host, port, username, accessKey),
    desired = exports.desired = {
      "browserName": "chrome",
      "version"    : "",
      "platform"   : "Linux",
      "tags"       : ["Scrabble", "test"],
      "name"       : "Scrabble tests",
      "public"     : "public",
      "build"      : process.env.TRAVIS_BUILD_NUMBER ? process.env.TRAVIS_BUILD_NUMBER : "dev-tests",
      "tunnel-identifier": process.env.TRAVIS_JOB_NUMBER ? process.env.TRAVIS_JOB_NUMBER : "Scrabble",
      "record-video": true
    };

browser.on("status", function(info) {
  console.log("\x1b[36m%s\x1b[0m", info);
});

browser.on("command", function(meth, path, data) {
  console.log(" > \x1b[33m%s\x1b[0m: %s", meth, path, data || "");
});
