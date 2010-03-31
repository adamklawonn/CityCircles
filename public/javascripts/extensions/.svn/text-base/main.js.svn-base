//Copyright 2008 Google Inc. 
//Licensed under the Apache License, Version 2.0:
//http://www.apache.org/licenses/LICENSE-2.0

/**
 * @fileoverview This file contains extensions to Selenium Core, which includes
 * this and the other *.js files via a script include.  Currently, this file
 * contains extensions to PageBot.
 */


/**
 * @type {Object} Namespace for all custom mfe= locators.
 */
var SeleniumMfe = {};


/**
 * Attempts to programatically update the name of the test to be the filename
 * of the test.  
 */
SeleniumMfe.setTestName = function() {
  var iFrame = document.getElementById('testFrame');
  var doc = iFrame.contentDocument || iFrame.contentWindow.document;
  var title_match = /selenium.tests.([^?]*)/.exec(doc.location.href);
  if (title_match && title_match[1]) {
    var tr = doc.getElementsByTagName('tr')[0];
    var td = tr.getElementsByTagName('td')[0];
    td.innerHTML = title_match[1];
  }
}


/**
 * Attempts to programatically update the test links in a suite to include
 * the test path.  Makes it easier to look at a suite and know what files it
 * refers to.
 */
SeleniumMfe.addTestPathsToSuite = function() {
  var iFrame = document.getElementById('testSuiteFrame');
  var doc = iFrame.contentDocument || iFrame.contentWindow.document;
  var anchors = doc.getElementsByTagName("a");
  for (var i = 0; i < anchors.length; ++i) {
    var title_match = /selenium.tests.([^?]*_test.html)/.exec(anchors[i].href);
    if (title_match && title_match[1]) {
      var elem = document.createElement('div');
      elem.style.fontSize = "x-small";
      elem.style.color = "grey";
      elem.innerHTML = title_match[1];
      anchors[i].parentNode.appendChild(elem);
    }
  }
}


/**
 * Locates an element in a document using locators returned by namespaced
 * javascript functions.
 *
 * MFE custom locator allows for clean namespace and shorter test
 * target, and allows us to compose xpaths.
 * @param {String} text Locator string minus the prefix.
 * @param {Document} doc Current document.
 * @return {Element|Null} The DOM element found, or null if not found.
 */
PageBot.prototype.locateElementByMfe = function(text, doc) {
  // This prefixes every mfe= call with the "SeleniumMfe" namespace.
  // 'mfe=getAnyVectorGraphic()" could evaluate to either an xpath query
  // or a dom query and we determine this from the prefix of the returned 
  // string.

  var command = eval("SeleniumMfe." + text);
  if (command.length > 4 && command.substring(0,4) == "dom=") {
    var domElement = command.substring(4);
    return selenium.browserbot.locateElementByDomTraversal(domElement, doc);
  }
  else if (command.length > 6 && command.substring(0,6) == "xpath=") {
    var xpath = command.substring(6);
    return selenium.browserbot.locateElementByXPath(xpath, doc);
  }
  else {
    //If we don't get an explicit query type, assume it is an xpath
    var xpath = command;
    return selenium.browserbot.locateElementByXPath(xpath, doc);
  }
};


/**
 * Locates an element in a document using an XPath and caches the result for
 * faster lookups in the future. This has a significant impact on browsers
 * that do not have native XPath support, since the XPath is only evaluated
 * once regardless of how many times the xpath is referenced in a test.
 * Notice that this only works for static XPaths. If an element might be
 * removed from the page do not use this locator.
 * Usage: staticxpath=...
 * Example: staticxpath=(//img[contains(@src,'marker.png')])[4]
 *
 * @param {string} text Locator string (a valid XPath) minus the prefix.
 * @param {Document} doc Current document.
 * @return {Element|Null} The DOM element found, or null if not found.
 */
PageBot.prototype.locateElementByStaticXPath = function(xpath, doc) {
  if (!doc.seleniumElementCache_) {
    doc.seleniumElementCache_ = {};
  }
  if (!doc.seleniumElementCache_[xpath]) {
    doc.seleniumElementCache_[xpath] =
        selenium.browserbot.locateElementByXPath(xpath, doc);
  }
  return doc.seleniumElementCache_[xpath];
};


// HACK: This function is defined in selenium-api.js without
// the last 'if' statement.  We overwrite the selenium defined
// function to add a workaround to be able to use the "waitforvisible"
// action without it failing on Safari. For a reference on the
// workaround see http://jira.openqa.org/browse/SEL-431
Selenium.prototype.findEffectiveStyle = function(element) {
  if (element.style == undefined) {
    return undefined; // not a styled element
  }
  if (window.getComputedStyle) {
    // DOM-Level-2-CSS
    return this.browserbot.getCurrentWindow().
    getComputedStyle(element, null);
  }
  if (element.currentStyle) {
    // non-standard IE alternative
    return element.currentStyle;
    // TODO: this won't really work in a general sense, as
    //   currentStyle is not identical to getComputedStyle()
    //   ... but it's good enough for "visibility"
  }

  if (window.document.defaultView &&
      window.document.defaultView.getComputedStyle) {
    return window.document.defaultView.
    getComputedStyle(element, null);
  }

  throw new SeleniumError(
      "cannot determine effective stylesheet in this browser");
};


// HACK: This function is defined in selenium-api.js without
// the try/catch block.  This effectively eats any exceptions which
// get thrown on open, which is bad, but necessary.
//
// Specifically, the old implementation of open will throw an
// exception any time it is called after the Mapplets gmodules.com
// iframe loads.  Selenium tries to determine what page the iframe
// contains with location.href, but since the iframe is pointing to a
// different domain, an exception is thrown.  Selenium catches this
// exception and stores in in a variable.  Finally, when open is
// called later on, Selenium inexplicably decides to throw the old
// exception.  Eww.
//
// This version eats the exception, so it will either succeed or
// timeout.  Enable logging to see what exception is being obscured.
Selenium.prototype._isNewPageLoaded = function() {
  try {
    return this.browserbot.isNewPageLoaded();
  } catch (e) {
    // pass
    LOG.info("Ignoring exception: " + e);
  }
};

/*
 * HACK: This function is defined in selenium-browserbot.js
 * without try/catch. Need to add try/catch pair to catch cross domain access
 * deny exception.
 */
BrowserBot.prototype.findElementRecursive = function(locatorType,
    locatorString, inDocument, inWindow) {
  var element = this.findElementBy(locatorType, locatorString,
                                   inDocument, inWindow);
  if (element != null) {
    return element;
  }

  for (var i = 0; i < inWindow.frames.length; i++) {
    try {
      l = inWindow.frames[i].location;
      element = this.findElementRecursive(locatorType, locatorString,
          inWindow.frames[i].document, inWindow.frames[i]);
    } catch(e) {}
    if (element != null) {
      return element;
    }
  }
};


/**
* Calls contextmenu for an element.
* @param {Selenium.Locator} locator  - an element locator.
*/
Selenium.prototype.doContextMenu = function(locator) {
  this.doContextMenuAt(locator,"0,0");
};


/**
* Calls contextmenu for an element.
* @param {Selenium.Locator} locator - an element locator.
* @param {String} coordString specifies the x,y position (i.e. - 10,20) of
*     the mouse event relative to the element returned by the locator.
*/
Selenium.prototype.doContextMenuAt = function(locator, coordString) {
  var element = this.browserbot.findElement(locator);
  var clientXY = getClientXY(element, coordString);
  this.browserbot._fireEventOnElement(
      "contextmenu", element, clientXY[0], clientXY[1]);
};


// HACK: This function is defined in selenium-api.js
// with the additional skipping of offsetParent elements when
// the offsetParent's offsetHeight is less than the current
// element's offsetHeight. This causes skipping an overflow
// container in case the content has larger height and is scrollable.
// It may produce different results for identically positioned elements
// due to one element's offsetHeight satisfying condition and another's not.
// Moreover, the element's top position "from the edge of frame"
// (according to Selenium reference) may be calculated incorrectly.
//
// This version is a copy of the original getElementPositionTop implementation
// without element skipping part.
/**
 * Retrieves the vertical position of an element in the frame.
 *
 * @param {Selenium.Locator|Element} locator An element locator
 *     or the element itself.
 * @return {number} number of pixels from the top edge of the frame.
 */
Selenium.prototype.getElementPositionTop = function(locator) {
  var element;
  if ("string" == typeof locator) {
    element = this.browserbot.findElement(locator);
  } else {
    element = locator;
  }

  var y = 0;

  while (element != null) {
    if(document.all) {
      if ((element.tagName != "TABLE") && (element.tagName != "BODY")) {
        y += element.clientTop;
      }
    } else { // Netscape/DOM
      if(element.tagName == "TABLE") {
        var parentBorder = parseInt(element.border);
        if(isNaN(parentBorder)) {
          var parentFrame = element.getAttribute('frame');
          if(parentFrame != null) {
            y += 1;
          }
        } else if(parentBorder > 0) {
          y += parentBorder;
        }
      }
    }
    y += element.offsetTop;

    // Next up...
    element = element.offsetParent;
  }
  return y;
};


