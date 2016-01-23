// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
// Pull compiled from /public/assets/javascripts
//= require pre-application
//= require_self
//

var preApplication = require('javascripts/pre-application');

var ready = window.ready = preApplication.notJquery.ready;

ready(function() {
  window.map = Object.create(preApplication.map);
  window.map.init();
  window.map.setCurrentPosition();
});

