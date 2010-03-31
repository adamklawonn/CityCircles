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
