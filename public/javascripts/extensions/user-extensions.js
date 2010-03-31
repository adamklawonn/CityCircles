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


//Copyright 2008 Google Inc. 
//Licensed under the Apache License, Version 2.0:
//http://www.apache.org/licenses/LICENSE-2.0

/**
 * @fileoverview This file contains locators and actions for the map.
 */


/**
 * @type {Object} Defines static map functions.
 */
SeleniumMfe.Map = {};


/**
 * Returns the xpath of the div that has id "map", which is the outer container
 * of the map.
 * @return {String} xpath of the outer map container.
 */
SeleniumMfe.Map.getOuterContainer = function() {
  // TODO: The "id" function has a bug in the xpath emulation
  // library (xpath.js), so we must append /. to id('map') to get it to work.
  return "id('map')/.";
};


/**
 * Returns the xpath of the map object created by the javascript.  The element
 * that has id "map" is actually the outer container of the map; its first div
 * is the inner container; finally, the inner container's first div is the
 * actual map div.
 * @return {String} xpath of the map.
 */
SeleniumMfe.Map.get = function() {
  return SeleniumMfe.Map.getOuterContainer() + "//div[1]//div[1]";
};


/**
 * Returns the xpath to an attribute of the map object.
 * @param {String} attr Attribute to get from the map.
 * @return {String} xpath of the map.
 */
SeleniumMfe.Map.getAttribute = function(attr) {
  return SeleniumMfe.Map.get() + "/@" + attr;
};

/**
 * Returns the xpath of all markers.
 *
 * @return {String} xpath for all markers.
 */
SeleniumMfe.Map.getMarkers = function() {
  return "//*[contains(@id, 'mtgt')]";
};

/**
 * Returns xpath of red marker that shows up on the map as a result of
 * a business search result.
 * @param {String} letter The letter inside the marker (e.g. marker('A')).
 * @return {String} xpath for red marker.
 */
SeleniumMfe.Map.getMarkerByLetter = function(letter) {
  var ieTarget = "id('mtgt_" + letter + "')/.";
  var mozillaTarget = "//area[@id='mtgt_" + letter + "']";

  return mozillaTarget + '|' + ieTarget;
};


/**
 * Returns the xpath for DOM element that serves as the marker mouse target for
 * the marker with the given id.  The mouse target for a marker depends on
 * whether the marker has a transparant icon or not and which browser the user
 * is using.  It is not necessarily the img element for the main marker image.
 *
 * @param {String} markerId The marker's 'id' attribute.
 * @return {String} xpath
 */
SeleniumMfe.Map.getMarkerMouseTarget = function(markerId) {
  return "id('mtgt_" + markerId + "')/.";
};


/**
 * Returns the xpath for DOM element that serves as the marker mouse target for
 * the marker identified by the given index.  The mouse target for a marker depends on
 * whether the marker has a transparant icon or not and which browser the user
 * is using.  It is not necessarily the img element for the main marker image.
 * This has been tested in IE, Firefox and Safari.
 *
 * @param {String} index The marker's 0-based index.
 * @return {String} xpath
 */
SeleniumMfe.Map.getMarkerMouseTargetByIndex = function(index) {
  return "id('mtgt_unnamed_" + index + "')/.";
};


/**
 * Returns xpath for a regular "w2.X" map tile.
 */
SeleniumMfe.Map.getRegularMapTileImage = function() {
  return SeleniumMfe.Map.get() + "//img[contains(@src, '&v=w2.')]";
};


/**
 * Returns xpath for a regular "cnX" China map tile.
 */
SeleniumMfe.Map.getChinaRegularMapTileImage = function() {
  return SeleniumMfe.Map.get() + "//img[contains(@src, 'v=cn')]";
};


/**
 * Returns xpath for a regular "w2.X" map tile.
 */
SeleniumMfe.Map.getApiRegularMapTileImage = function() {
  return SeleniumMfe.Map.get() + "//img[contains(@src, '&v=ap.')]";
};


/**
 * Returns xpath for a satellite "/kh" map tile.
 */
SeleniumMfe.Map.getSatelliteTileImage = function() {
  return SeleniumMfe.Map.get() + "//img[contains(@src, '/kh')]";
};


/**
 * Returns the xpath for any vector graphic map element.
 * For 'svg' elements to be matched (in Mozilla)
 * we must also use the Selenium action allowNativeXpath(false)
 * because native Xpath cannot match elements in anonymous namespaces.
 * @return {String} xpath expression for svg|shape|img[dynamic-tile-server]
 */
SeleniumMfe.Map.getAnyVectorGraphic = function() {
  var mozillaTarget = "id('map')//svg:svg";
  var otherTarget = "id('map')//canvas";

  if (browserVersion.isIE) {
    return "dom=document.getElementsByTagName(\"shape\")[0]";
  }
  else {
    return mozillaTarget + "|" + otherTarget;
  }
};


/**
 * Returns the xpath for the blue-dot marker added by
 * a KML Point Placemark.
 * @return {String} xpath expression for the marker img element.
 */
SeleniumMfe.Map.getBlueDotMarker = function() {
  return SeleniumMfe.Map.getImage('blue-dot');
};


/**
 * Returns the xpath for an image whose source attribute contains
 * the supplied name: e.g. 'pretty.jpg'. On IE KML GroundOverlays
 * produce images in divs so this case is catered for.
 *
 * NOTE: Assumes map div has id of 'map'.
 *
 * @param {String} name Any text appearing in the src or __src__ attribute.
 * @return {String} xpath expression to locate the img or div element.
 */
SeleniumMfe.Map.getImage = function(name) {
  var mozillaTarget = "id('map')/.//img[contains(@src,'" + name + "')]";
  var ieTarget =    "(id('map')/.//img[contains(@__src__,'" + name + "')])";
  var ieDivTarget = "(id('map')/.//div[contains(@src,'" + name + "')])";
  return mozillaTarget + '|' + ieTarget + '|' + ieDivTarget;
};

/**
 * Get an instance of the GMap object. This assumes that the map instance is
 * stored in a global variable called map.
 *
 * @return {GMap} The GMap instance stored in the global variable 'map'
 */
SeleniumMfe.Map.getInstance_ = function(name) {
  return selenium.browserbot.getCurrentWindow()['map']; 
}

//Copyright 2008 Google Inc. 
//Licensed under the Apache License, Version 2.0:
//http://www.apache.org/licenses/LICENSE-2.0

/**
 *
 * @fileoverview This file contains extensions to Selenium Core related
 * to custom maps actions and assertions.
 */


/*** ACTIONS ***/

/**
 * Adds a pause of optional length between each Selenium step.
 * This action is used at the beginning of flaky tests to slow
 * them down, which helps stabilize them in many cases.
 * @param {Number} opt_time Optional time to wait between steps.
 *   if no paramter is given, it defaults to 1000ms.
 */
Selenium.prototype.doPauseBetweenSteps = function(opt_time) {
  time = opt_time || 1000;
  htmlTestRunner.controlPanel.setRunInterval(time);
};


/**
 * Simulates a click on the map by doing a mouse down/mouse up at the
 * given locator.  The built in doClickAt function doesn't work
 * on the map element because the MFE js listens specifically for
 * mousedown and mouseup events, not click events.
 * @param {String} locator The map that is being clicked on.
 */
Selenium.prototype.doMapClick = function(locator) {
  this.doMouseDown(locator);
  this.doMouseUp(locator);
};


/**
 * Simulates a click on the map by doing a mouse down/mouse up at the
 * given locator and location relative to the located element.  The
 * built in doClickAt function doesn't work on the map element because
 * the MFE js listens specifically for mousedown and mouseup events,
 * not click events.
 * @param {String} locator The map that is being clicked on.
 * @param {String} coordString Comma separated coordinates of the click
 *    (e.g., "5,5").
 */
Selenium.prototype.doMapClickAt = function(locator, coordString) {
  this.doMouseDownAt(locator, coordString);
  this.doMouseUpAt(locator, coordString);
};


/**
 * Takes geographic coordinates (lat/lng) and convert them to pixel coordinates
 * on the map div.
 * @param {String} coordString Comma separated geographic coordinates.
 * @return {String} Comma separated pixel coordinates.
 */
Selenium.prototype.latLngToDivPixel_ = function(coordString) {
  var coords = coordString.split(',');
  // Construct a fake LatLng object (the real constructor is not accessible
  // from here).
  var latLng = {
      x: new Number(coords[1]),
      y: new Number(coords[0]),
      lat: function() { return this.y; },
      lng: function() { return this.x; }
  };
 // For the API, get the map by finding a global variable called 'map'
  var map = SeleniumMfe.Map.getInstance_();
  var divPx = map.fromLatLngToDivPixel(latLng);
  return divPx.x + ',' + divPx.y;
};


/**
 * Simulates a click event on the map given geographic coordinates.
 * @param {String} locator The map locator.
 * @param {String} coordString Comma separated geographic coordinates
 *     of the click (lat,lng).
 * @return {String}
 */
Selenium.prototype.doMapClickAtLatLng = function(locator, coordString) {
  this.doMapClickAt(locator, this.latLngToDivPixel_(coordString));
};


/**
 * Simulates a mousemove event on the map given geographic coordinates.
 * @param {String} locator The map locator.
 * @param {String} coordString Comma separated geographic coordinates
 *     of the click (lat,lng).
 * @return {String}
 */
Selenium.prototype.doMapMouseMoveAtLatLng = function(locator, coordString) {
  this.doMouseMoveAt(locator, this.latLngToDivPixel_(coordString));
};


/**
 * Brings the element identified by the locator given as an argument into
 * focus.
 * @param {String} locator of the element that needs to brought into focus.
 */
Selenium.prototype.doFocus = function(locator) {
  var node = this.browserbot.findElement(locator);
  node.focus();
};


/**
 * Brings the element identified by the locator given as an argument out
 * of focus.
 * @param {String} locator of the element that needs to brought out of focus.
 */
Selenium.prototype.doBlur = function(locator) {
  var node = this.browserbot.findElement(locator);
  node.blur();
};


/**
 * Simulates a drag-and-drop of the map by doing a mouse down/mouse up at the
 * given locator and location relative to the located element.  The built in
 * doDragAndDrop function doesn't work for some reason.  Note that this version
 * only triggers a single "mousemove" event unlike the built in doDragAndDrop
 * which does a number of interpolated moves during the drag.
 * @param {String} locator The map that is being dragged.
 * @param {String} movementString Offset in pixels from the current
 *   location to which the element should be moved, e.g., "+70,-300".
 */
Selenium.prototype.doMapDragAndDrop = function(locator, movementsString) {
  // We strip the '+' by converting to numbers and back to strings.
  var movements = movementsString.split(',');
  var movementX = Number(movements[0]);
  var movementY = Number(movements[1]);
  var endCoordString = String(movementX) + "," + String(movementY);
  this.doMouseDownAt(locator, "0,0");
  this.doMouseMoveAt(locator, endCoordString);
  this.doMouseUpAt(locator, endCoordString);
};


/**
 * Builds a function that waits for its first argument to be visible
 * and then does some action.
 * @param {Function} subsequentAction Selenium.prototype.doSomething
 * @return {Function} a new Selenium command
 */
Selenium._makeWaitForThenAction = function(subsequentAction) {
  return function(locator, opt_otherArg) {
    var me = this;
    return Selenium.decorateFunctionWithTimeout(function() {
      if (me.isPresentAndVisible(locator)) {
        subsequentAction.bind(me)(locator, opt_otherArg);
        return true;
      } else {
        return false;
      }
    }, me.defaultTimeout);
  }
}


/**
 * Waits for an element to be visible and then clicks on it.
 * @param {String} locator The element that is being clicked on.
 * @return {Function} callback that Selenium uses to determine when
 *     the command is complete
 */
Selenium.prototype.doWaitForThenClick =
    Selenium._makeWaitForThenAction(Selenium.prototype.doClick);


/**
 * Waits for a textbox to be visible and then types into it.
 * @param {String} locator The element that is being typed into.
 * @param {String} text Text to type.
 * @return {Function} callback that Selenium uses to determine when
 *     the command is complete
 */
Selenium.prototype.doWaitForThenType =
    Selenium._makeWaitForThenAction(Selenium.prototype.doType);


/*** ASSERTIONS ***/

/**
 * Determines if the GLog console a message that matches the given pattern.
 *
 * Implicity defines isGLogContains, assertGLogContains, verifyGLogContains,
 * assertNotGLogContains, verifyNotGLogContains, storeGLogContains,
 * waitForGLogContains, and waitForNotGLogContains.
 *
 * @param {string} expectedPattern The pattern to search for in the log.
 * @return {boolean} GLog contains the expected pattern.
 */
Selenium.prototype.isGLogContains = function(expectedPattern) {
  var clientWindow = this.browserbot.getCurrentWindow();
  if (clientWindow && clientWindow.GLog && clientWindow.GLog.getMessages) {
    var contents = clientWindow.GLog.getMessages();
    var length = contents.length;
    for (var i = 0; i < length; ++i) {
      if (PatternMatcher.matches(expectedPattern,contents[i])) {
        return true;
      }
    }
    return false;
  } else {
    throw new SeleniumError("Call to GLog.getMessages() failed");
  }
};


/**
 * Determines if the given attribute locator has the specified substring.
 * An attribute locator uses "@" to prefix the attribute, e.g.
 * "//input/@class" finds an input with the "class" attribute.
 *
 * Implicitly defines verifyAttributeContains, assertAttributeContains, and
 * waitForAttributeContains.
 *
 * @return true if the locator is an attribute that contains textToFind.
 *
 * @deprecated Use | verifyAttribute | locator | *textToFind* | instead
 */
Selenium.prototype.isAttributeContains = function(locator, textToFind) {
  var node = this.browserbot.findElement(locator);
  return node.nodeValue.indexOf(textToFind) != -1;
};


/**
 * Gets the value of the property of the style of an element.  Using
 * getAttribute for getting the style attribute works on firefox, but
 * not on IE, hence the need for a special getter.  This getter is
 * also a bit clearer when used in a test.  Note that the style
 * needs to be in JS notation, e.g. backgroundColor not background-color.
 *
 * Implicitly defines verifyStyleProperty, assertStyleProperty, and
 * waitForStyleProperty.
 *
 * @param {String} propertyLocator an element locator followed by an
 *   '$' sign and then the name of the style propery, e.g. id=map$top.
 *
 * @return {String} The value of the style property.
 */
Selenium.prototype.getStyleProperty = function(propertyLocator) {
  var loc = this.parseLocator_(propertyLocator, "$");

  var result = null;

  if (loc.element) {
    result = this.findEffectiveStyleProperty(loc.element, loc.propertyName);
  }

  if (result == null) {
    throw new SeleniumError("Could not find element style property: " +
                            propertyLocator);
  }
  return result;
};


/**
 * Checks that an element is both present and visible.
 *
 * isVisible assumes the element is present and can behave strangely
 * if it's not. This function checks if the element is both present and
 * visible, and such is more robust.
 */
Selenium.prototype.isPresentAndVisible = function(locator) {
  var element = this.browserbot.findElementOrNull(locator);
  if (element == null) return false;
  var visibility = this.findEffectiveStyleProperty(element, "visibility");
  return visibility != "hidden" && this._isDisplayed(element);
};


/**
 * Rewrites the target attribute of the link with given id.
 * @param {string} locator The locator of the link to modify.
 * @param {string} target The new target value.
 */
Selenium.prototype.doRewriteLinkTarget = function(locator, target) {
  var doc = this.browserbot.getCurrentWindow().document;
  var link = this.browserbot.findElementOrNull(locator);
  link.target = target;
};


/**
 * Rewrites the target attribute of the link in an embedded map with given id.
 * @param {string} locator The locator of the link to modify.
 * @param {string} target The new target value.
 */
Selenium.prototype.doRewriteEmbedLinkTarget = function(locator, target) {
  var doc = this.browserbot.getCurrentWindow().frames[0].document;
  var link = doc.getElementById(locator);
  link.target = target;
};


/**
 * Opens a popup of the given name.
 */
Selenium.prototype.doOpenPopup = function(windowId) {
  this.browserbot.getCurrentWindow().open('', windowId);
};



/**
 * Firefox's disk-cache hashing algorithm. See
 * http://lxr.mozilla.org/seamonkey/source/netwerk/cache/src/
 *   nsDiskCacheDevice.cpp#251
 *
 * @param {string} url  The full url string, e.g.
 *                      http://www.google.com/images/logo.gif
 * @return {number}  Firefox's url 32-bit hash value.
 */
Selenium.firefoxHash_ = function(url) {
  var len = url.length;
  var h = 0;
  for (var i = 0; i < len; i++) {
    h = (h >>> 28) ^ (h << 4) ^ url.charCodeAt(i);
  }
  return h;
}


/**
 * Indices used to add commands in the correct order.  If multiple commands are
 * added at the same time, they will be added in FIFO order.
 */
Selenium.prototype.lastCommand_ = -1;
Selenium.prototype.nextAvailableHtml = -1;
Selenium.prototype.nextAvailableCommand = -1;


/**
 * Returns true if commands have already been added at this point of the
 * script.  This should be checked before commands are added to prevent
 * duplicates when the script is run twice.
 */
Selenium.prototype.isCommandExpanded = function() {
  var commandTable =
    sel$A(currentTest.htmlTestCase.testDocument.getElementsByTagName(
          "table"))[0];
  var rowI = currentTest.htmlTestCase.nextCommandRowIndex;
  var tableI =
    currentTest.htmlTestCase.commandRows[rowI-1].trElement.rowIndex+1;
  var regex = new RegExp(".*auto.*");
  if (tableI < commandTable.rows.length &&
      commandTable.rows[tableI].getAttribute("class") != null &&
      commandTable.rows[tableI].getAttribute("class").match(regex)) {
    // The rows have already been added.
    return true;
  }
  return false;
}


/**
 * Adds a command to the test after the current command.  If multiple commands
 * are added in sequence, they will be executed in the order added.
 *
 * @param {string} td0,td1,td2 The three values from the <td> elements in
 *                             Selenese.
 */
Selenium.prototype.addCommandToTest = function(td0, td1, td2) {
  var commandTable =
    sel$A(currentTest.htmlTestCase.testDocument.getElementsByTagName(
          "table"))[0];
  var rowI = currentTest.htmlTestCase.nextCommandRowIndex;
  var tableI =
    currentTest.htmlTestCase.commandRows[rowI - 1].trElement.rowIndex + 1;

  if (rowI == this.lastCommand_ && this.isCommandExpanded()) {
    // Commands have been added after this command before.
    tableI = this.nextAvailableHtml_;
    rowI = this.nextAvailableCommand_;
  }
  var expandedRow = commandTable.insertRow(tableI);
  var expandedCell0 = expandedRow.insertCell(0);
  expandedCell0.innerHTML = td0;
  expandedCell0.style.cssText = "text-indent: 1em";
  var expandedCell1 = expandedRow.insertCell(1);
  expandedCell1.innerHTML = td1;
  var expandedCell2 = expandedRow.insertCell(2);
  expandedCell2.innerHTML = td2;
  expandedRow.setAttribute("class", "auto");
  currentTest.htmlTestCase.commandRows.splice(rowI, 0,
    new HtmlTestCaseRow(expandedRow));
  currentTest.htmlTestCase._addBreakpointSupport();

  // Remember that we were here
  this.lastCommand_ = currentTest.htmlTestCase.nextCommandRowIndex;
  this.nextAvailableHtml_ = tableI + 1;
  this.nextAvailableCommand_ = rowI + 1;
}



/**
 * Sets the specified property of an element. Besides attributes which
 * are understood as the ones explicitly specified in HTML or inherited
 * from those, there are DOM properties of elements which are calculated
 * and dynamic by nature, e.d. "scrollTop". Selenium core methods dealing
 * with attributes do not handle these properties.
 *
 * @param {string} locator of the element with "@"-delimited property,
 *   e.g. id=spsizer@scrollTop.
 * @param {string} value The value to set the property to.
 */
Selenium.prototype.doSetElementProperty = function(locator, value) {
  var loc = this.parseLocator_(locator, "@");
  loc.element[loc.propertyName] = value;
};


/**
 * Returns the element property. See comment for doSetElementProperty()
 * for explanation for attributes vs. properties. Note that for some
 * attributes this method may return different result than
 * Selenium.getAttribute.
 *
 * @param {string} locator of the element with "@"-delimited property,
 *   e.g. id=spsizer@scrollTop.
 * @return {string} The value of the element's property.
 */
Selenium.prototype.getElementProperty = function(locator) {
  var loc = this.parseLocator_(locator, "@");
  var result = loc.element[loc.propertyName];

  if (result == null) {
    throw new SeleniumError("Could not find element property: " +
                            locator);
  }
  return result;
};


/**
 * Parses the string containing element locator and its property in delimited
 * form (i.e. "id=spsizer@scrollTop").
 *
 * @param {string} locator Delimited string containing element locator and
 *   its property.
 * @param {string} delimiter
 * @return {PropertyLocator}
 * @private
 */
Selenium.prototype.parseLocator_ = function(locator, delimiter) {
  return new PropertyLocator(locator, delimiter);
}


/**
 * Container class for DOM element and its property name parsed from
 * constructor argument.
 *
 * @param {string} locator Delimited string containing element locator and
 *   its property. The element locator must specify a valid DOM element
 *   (otherwise Selenium exception is thrown), but the property name is
 *   interpreted as an arbitrary text in this class and its semantics are
 *   determined by the caller.
 * @param {string} delimiter
 * @constructor
 */
function PropertyLocator(locator, delimiter) {
  var attributePos = locator.lastIndexOf(delimiter);
  var elementLocator = locator.slice(0, attributePos);

  /**
   * @type {string}
   */
  this.propertyName = locator.slice(attributePos + 1);

  /**
   * @type {Element}
   */
  this.element = selenium.browserbot.findElement(elementLocator);
}

/**
 * Adds an event listener to the map and assigns the event to a selenium
 * variable. This variable can be polled to verify whether the event has
 * occurred.
 * 
 * NOTE: This test reserves the selenium variable object_name+click_name,
 *   i.e. mapclick when listening to the "click" event on an object called
 *   map.
 *
 *  @param {String} object_name The name of an object to add the event to. 
 *    The object MUST be a global javascript object in the page being tested.
 *  @param {String} event_name The name of the event to add a listener to.
 **/
Selenium.prototype.doAddGEventListener = function(object_name, event_name) {
  var clientWindow = this.browserbot.getCurrentWindow(); 
  var obj = clientWindow[object_name];
  if (obj) {
    if (!selenium.storedVars) {
      selenium.storedVars = new Object();
    }
    selenium.storedVars[object_name + event_name] = false;
    clientWindow.GEvent.addListener(obj, event_name, function () { 
  	selenium.storedVars[object_name + event_name] = true;
   });
  } else {
    throw new SeleniumError('Object: "' + object_name + " not found.");
  }
};

/**
 * Waits for a GEvent to occur on an object. The event MUST have been
 * added using the addGEventListener selenium command first.
 *
 *  @param {String} object_name The name of an object to add the event to. 
 *    The object MUST be a global javascript object in the page being tested.
 *  @param {String} event_name The name of the event to add a listener to.
 */
Selenium.prototype.doWaitForGEvent = function(object_name, event_name) {
  var selenium_variable = object_name + event_name;
  var command = 'selenium.storedVars["' + selenium_variable + '"] == true;';
  return this.doWaitForCondition(command, Selenium.DEFAULT_TIMEOUT);
};
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
//Copyright 2008 Google Inc. 
//Licensed under the Apache License, Version 2.0:
//http://www.apache.org/licenses/LICENSE-2.0

/**
 *
 * @fileoverview This file contains extensions to Selenium Core related
 * to MFE locators in the small infowindow.
 */


/**
 * @type {Object} Defines static infowindow functions.
 */
SeleniumMfe.InfoWindow = {};

/**
 * Returns xpath of small infowindow.
 * @return {String} xpath for infowindow.
 */
SeleniumMfe.InfoWindow.get = function() {
  return SeleniumMfe.Map.getImage('iw3') || SeleniumMfe.Map.getImage('iw2')
    || "id('map')/.//*[contains(@class, 'iwMap')]";
};


/**
 * Returns xpath of small infowindow close icon sprite.
 * @return {String} xpath for infowindow close icon.
 */
SeleniumMfe.InfoWindow.getCloseIcon = function(opt_img) {
  return "id('map')/.//img[contains(@src, 'iw_close')]";
};


/**
 * Returns xpath of small infowindow close icon image used in the API.
 * @return {String} xpath for infowindow close icon.
 */
SeleniumMfe.InfoWindow.getCloseIconApi = function(opt_img) {
  return "id('map')/.//img[contains(@src, 'iw_close')]";
};


/**
 * Returns xpath of the "basics" section in the small infowindow.
 * @return {String} xpath for infowindow basics.
 */
SeleniumMfe.InfoWindow.getBasics = function() {
  return "id('basics')/.";
};


/**
 * Returns xpath of the "title" in the small infowindow.
 * @return {String} xpath for infowindow title.
 */
SeleniumMfe.InfoWindow.getTitle = function() {
  return SeleniumMfe.InfoWindow.getBasics() +
      "/div[@class='title']/span/span/span";
};


/**
 * Returns xpath of the "title" link in the small infowindow of an embedded map.
 * @return {String} xpath for infowindow title link in the embedded map.
 */
SeleniumMfe.InfoWindow.getEmbeddedMapTitleLink = function() {
  return SeleniumMfe.InfoWindow.getBasics() +
      "/div[@class='title']/span/span[@jsdisplay='features.embed']/a";
};


/**
 * Returns xpath of address of geocoded result inside the infowindow.
 * @return {String} xpath for infowindow address.
 */
SeleniumMfe.InfoWindow.getAddress = function() {
  return SeleniumMfe.InfoWindow.getBasics() +
      "//td[@class='basicinfo']//div[@class='addr adr']//span//span//span";
};


/**
 * Get the instance of the currently open infowindow, if one exists.
 * 
 * @return {GInfoWindow} The GInfoWindow instance currently associated with the
 *   global 'map' object.
 */
SeleniumMfe.InfoWindow.getInstance_ = function() {
  return SeleniumMfe.Map.getInstance_().getInfoWindow();
}


/**
 * Get the lat,lng co-ordinates of the currently open infowindow, if one exists.
 *
 * @return {String} The lat,lng of the current open infowindow, formatted as
 *   lat,lng.
 */
SeleniumMfe.InfoWindow.getLatLng = function() {
  return this.getInstance_().getPoint().toUrlValue();
}
