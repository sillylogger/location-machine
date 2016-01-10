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

function hydrateLatLng(latId, lngId) {
  var lattitudeInput = document.getElementById(latId);
  var longitudeInput = document.getElementById(lngId);

  window.map.addListener('click', function(e) {
    if(window.lastMarker) {
      window.lastMarker.setMap(null);
    }

    var marker = new google.maps.Marker({
      position: e.latLng,
      map: map
    });

    lattitudeInput.value = e.latLng.lat();
    longitudeInput.value = e.latLng.lng();

    window.lastMarker = marker;
  });
}

function placeEvents(events) {
  for(index in events) {
    var e = events[index];

    var eventLocation = new google.maps.LatLng(e.latitude, e.longitude);

    var marker = new google.maps.Marker({
      position: eventLocation,
      map: window.map,
      title: e.name
    });

    // window.map.panTo(marker.getPosition());
  }
}

function setCurrentPosition(position) {
  console.log("Geolocation is available.");
  if(!position.coords) { return; }

  var currentLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

  var marker = new google.maps.Marker({
    position: currentLocation,
    map: window.map,

    'clickable': false,
    'cursor': 'pointer',
    'draggable': false,
    'flat': true,
    'icon': {
      'url': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABHNCSVQICAgIfAhkiAAAAF96VFh0UmF3IHByb2ZpbGUgdHlwZSBBUFAxAABo3uNKT81LLcpMVigoyk/LzEnlUgADYxMuE0sTS6NEAwMDCwMIMDQwMDYEkkZAtjlUKNEABZgamFmaGZsZmgMxiM8FAEi2FMnxHlGkAAADqElEQVRo3t1aTWgTQRQOiuDPQfHs38GDogc1BwVtQxM9xIMexIN4EWw9iAehuQdq0zb+IYhglFovClXQU+uhIuqh3hQll3iwpyjG38Zkt5uffc4XnHaSbpLZ3dnEZOBB2H3z3jeZN+9vx+fzYPgTtCoQpdVHrtA6EH7jme+/HFFawQBu6BnWNwdGjB2BWH5P32jeb0V4B54KL5uDuW3D7Y/S2uCwvrUR4GaEuZABWS0FHhhd2O4UdN3FMJneLoRtN7Y+GMvvUw2eE2RDh3LTOnCd1vQN5XZ5BXwZMV3QqQT84TFa3zuU39sy8P8IOqHb3T8fpY1emoyMSQGDI/Bwc+0ELy6i4nLtepp2mE0jc5L3UAhMsdxut0rPJfRDN2eMY1enF8Inbmj7XbtZhunkI1rZFD/cmFMlr1PFi1/nzSdGkT5RzcAzvAOPU/kVF9s0ujqw+9mP5QgDmCbJAV7McXIeGpqS3Qg7OVs4lTfMD1Yg9QLR518mZbImFcvWC8FcyLAbsev++3YETb0tn2XAvouAvjGwd14YdCahUTCWW6QQIzzDO/CIAzKm3pf77ei23AUkVbICHr8pnDZNynMQJfYPT7wyKBzPVQG3IvCAtyTsCmRBprQpMawWnkc+q2Rbn+TK/+gmRR7qTYHXEuZkdVM0p6SdLLYqX0LItnFgBxe3v0R04b5mGzwnzIUMPiBbFkdVmhGIa5tkJ4reZvyl4Rg8p3tMBh+FEqUduVRUSTKTnieL58UDG76cc70AyMgIBxs6pMyIYV5agKT9f/ltTnJFOIhuwXOCLD6gQ/oc8AJcdtuYb09xRQN3NWULgCwhfqSk3SkaBZViRTK3EYNUSBF4Hic0Y8mM+if0HhlMlaIHbQ8Z5lszxnGuIP2zrAw8J8jkA7pkMAG79AKuPTOOcgWZeVP5AsSDjAxWegGyJoSUWAj/FBpRa0JiviSbfldMqOMPcce7UVeBLK4gkMVVBLI2phLjKlIJm8lcxMNkLuIomXOTTmc1kwYf2E+nMQdzlaTTKgoaZJWyBQ141RY0DkrK6XflAQbih1geZnhJeXu5WeEZ3mVqSkrIgCzXJaXqoh65TUuLerdtFXgQ2bYKeD1pq6hobLE86SlztXMWvaA5vPO0sYWB9p2K1iJS4ra0Fju/udsN7fWu+MDRFZ+YuuIjX1d8Zu2OD92WC9G3ub1qABktBV7vssfBMX1L7yVjZ7PLHuABb9svezS7boNDyK/b4LdX123+Au+jOmNxrkG0AAAAAElFTkSuQmCC',
      'size': new google.maps.Size(48, 48),
      'scaledSize': new google.maps.Size(24, 24),
      'origin': new google.maps.Point(0, 0),
      'anchor': new google.maps.Point(8, 8)
     },

     // This marker may move frequently - don't force canvas tile redraw
     'optimized': false,
     'title': 'Current location',
     'zIndex': 2
  });

  window.map.panTo(marker.getPosition());
  window.map.setZoom(12);
}

function failCurrentPosition() {
  console.log("Geolocation refused?");
}

ready(function() {
  console.log("Ready");

  var mapCanvas = document.getElementById('map_canvas');
  if(!mapCanvas) { return; }

  window.map = initializeMap(mapCanvas);

  setTimeout(function() {
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(setCurrentPosition, failCurrentPosition);
    } else {
      console.log("Geolocation is not available.");
    }
  }, 250);

});

