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
