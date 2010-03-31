//Copyright 2008 Google Inc.
//Licensed under the Apache License, Version 2.0:
//http://www.apache.org/licenses/LICENSE-2.0

/**
 *
 * @fileoverview This file contains locators and actions for api testing.
 */

/**
 * Edit the text in any textbox.
 */
Selenium.prototype.doReplaceText = function(id, text) {
  var element = this.page().findElement(id);
  this.page().replaceText(element, text);
};

/**
 * This modification of the open method passes arguments of the suite url
 * to the individual tests.
 *
 * Appends the test's query-parameters after the selenium-wide parameters,
 * to ensure that the test's parameters take precedence.
 */
Selenium.prototype.doOpenWithArgs = function(url) {
  // Captures everything after the ?. There will always be at least one
  // URL arg after the ? to specify the selenium suite.
  var base_args = document.location.href.match("\\?(.*)")[1];
  // Looks for arguments passed in to the test URL.
  var test_url_components = url.match("(.*)\\?(.*)");
  if (test_url_components) {
    var test_path = test_url_components[1];
    var test_args = test_url_components[2];
    // Arguments passed in by the test HTML are appended last to ensure that they
    // are able to override selenium-wide arguments.
    var new_url = test_path + '?' + base_args + '&' + test_args;
  } else {
    var new_url = url + '?' + base_args;
  }

  this.browserbot.openLocation(new_url);
  if (window["proxyInjectionMode"] == null || !window["proxyInjectionMode"]) {
      return this.makePageLoadCondition();
  } // in PI mode, just return "OK"; the server will waitForLoad
}
