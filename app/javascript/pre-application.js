let utils = require('not-jquery');
let Map = require('map');

module.exports = function run() {
  window.utils = utils;

  utils.ready(function() {
    window.map = new Map();

    if(window.map.isInitialized()) {
      window.map.setCurrentPosition();
    }

  });

};
