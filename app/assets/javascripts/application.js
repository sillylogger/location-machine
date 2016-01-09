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
//= require not-jquery
//= require_self


function initializeMap(canvas) {
  var jakarta = new google.maps.LatLng(-6.1745, 106.8227);

  var mapOptions = {
      center: jakarta,
      zoom: 8,
      scrollwheel: true,
      draggable: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var map = new google.maps.Map(canvas, mapOptions);

  map.set('styles', [{
    featureType: 'landscape',
    elementType: 'geometry',
    stylers: [
      { hue: '#ffff00' },
      { saturation: 30 },
      { lightness: 10}
    ]}
  ]);

  return map;
}

function setCurrentPosition(position) {
  console.log("Geolocation is available.");
  if(!position.coords) { return; }

  var currentLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

  var marker = new google.maps.Marker({
    position: currentLocation,
    map: window.map
  });

  window.map.panTo(marker.getPosition());
  window.map.setZoom(12);
}

ready(function() {
  console.log("Ready");

  var mapCanvas = document.getElementById('map_canvas');
  if(!mapCanvas) { return; }

  window.map = initializeMap(mapCanvas);

  setTimeout(function() {

    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(setCurrentPosition);
    } else {
      console.log("Geolocation is not available.");
    }

  }, 1);

});

