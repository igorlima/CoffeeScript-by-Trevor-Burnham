var integrationTest = require('./sauce-javascript-tests-integration.js');

integrationTest(
  "http://localhost:8080",
  "{failedCount: jasmine.currentEnv_.currentRunner_.results().failedCount}"
);
