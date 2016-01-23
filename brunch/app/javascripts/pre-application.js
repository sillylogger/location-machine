"use strict";

var notJquery = require('javascripts/shared/not-jquery');
var map = require('javascripts/map');

// Better Architecture:
//  map:
//  -- init() uses findOrCreateMap();
//  -- hydrateLatLng(id, id) uses getMap()
//  -- placeEventsOnMap() uses getMap()
//  -- setCurrent


var preApplication = {
  notJquery: notJquery,
  map: map
};

module.exports = preApplication;

