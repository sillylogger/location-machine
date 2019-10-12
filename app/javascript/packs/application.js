/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

window.lm = {};
window.lm.utils = require('not-jquery');
window.lm.Map = require('map');
window.lm.item = require('item');
window.lm.search = require('search');
window.lm.location = require('location');

require('native-share');

import Rails from 'rails-ujs';
Rails.start();
