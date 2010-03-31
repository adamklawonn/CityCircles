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
