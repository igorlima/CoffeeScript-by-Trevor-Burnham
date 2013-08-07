var launcher  = require('sauce-connect-launcher'),
    config    = require('./sauce-conf.js'),
    integrationTest = require('./sauce-javascript-tests-integration.js'),
    argv      = config.argv,
    localhost = argv.localhostSL || "http://localhost:8080",
    jsTestReporter = "{failedCount: jasmine.currentEnv_.currentRunner_.results().failedCount}";


argv.connect || integrationTest(localhost,jsTestReporter);

argv.connect && launcher(config.launcherOptions, function (err, sauceConnectProcess) {
  console.log("Started Sauce Connect Process");
  integrationTest(localhost, jsTestReporter, function() {
    sauceConnectProcess.close(function () {
      console.log("Closed Sauce Connect process");
    });
   });
});
