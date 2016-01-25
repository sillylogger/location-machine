let utils = require('javascripts/shared/not-jquery');
let Map = require('javascripts/map');

module.exports = function run() {

  utils.ready(function() {
    window.map = new Map();

    if(window.map.isInitialized()) {
      window.map.setCurrentPosition();
    }

  });

};
