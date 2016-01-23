"use strict";

var map = {

  _map: null,
  _lastMarker: null,

  init: function() {
    if(!window.google) {
      console.log("map.init - google not loaded");
      return null;
    }

    this.map();

    return {
      hydrateLatLng: this.hydrateLatLng,
      placeEventsOnMap: this.placeEventsOnMap,
      setCurrentPosition: this.setCurrentPosition
    };
  },

  map: function() {
    if(this._map) { return this._map; }

    var canvas = document.getElementById('map_canvas');
    if(!canvas) {
      console.log("initializeMap - mapCanvas isn't on this page");
      return;
    }

    var jakarta = new google.maps.LatLng(-6.1745, 106.8227);

    var mapOptions = {
        center: jakarta,
        zoom: 8,
        scrollwheel: true,
        draggable: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    this._map = new google.maps.Map(canvas, mapOptions);

    this._map.set('styles', [{
      featureType: 'landscape',
      elementType: 'geometry',
      stylers: [
        { hue: '#ffff00' },
        { saturation: 30 },
        { lightness: 10 }
      ]}
    ]);
  },

  hydrateLatLng: function (latId, lngId) {
    var lattitudeInput = document.getElementById(latId);
    var longitudeInput = document.getElementById(lngId);

    // if(!window.map) {
    //   console.log("hydrateLatLng - map not yet initialized");
    //   return;
    // }

    this.map().addListener('click', function(e) {

      if(this._lastMarker) {
        this._lastMarker.setMap(null);
      }

      var marker = new google.maps.Marker({
        position: e.latLng,
        map: this.map()
      });

      lattitudeInput.value = e.latLng.lat();
      longitudeInput.value = e.latLng.lng();

      this._lastMarker = marker;
    }.bind(this));
  },

  placeEvents: function (events) {
    events.forEach(function(e) {
      var eventLocation = new google.maps.LatLng(e.latitude, e.longitude);

      var marker = new google.maps.Marker({
        position: eventLocation,
        map: this.map(),
        title: e.name
      });

      google.maps.event.addListener(marker, 'click', function () {
        var infowindow = new google.maps.InfoWindow({
          content: e.name,
          maxWidth: 300
        });

        infowindow.open(this.map(), marker);
      }.bind(this));
    }.bind(this));
  },

  setCurrentPosition: function() {
    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
          this.setCurrentPositionSuccess.bind(this),
          this.setCurrentPositionFail.bind(this)
      );
    } else {
      console.log("ready - navigator.geolocation not available");
    }
  },

  setCurrentPositionSuccess: function (position) {
    console.log("setCurrentPosition - navigator.geolocation.getCurrentPosition success");
    if(!position.coords) { return; }

    var currentLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    window.currentLocation = currentLocation;

    var marker = new google.maps.Marker({
      position: currentLocation,
      map: this.map(),

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

    this.map().panTo(marker.getPosition());
    this.map().setZoom(12);
  },


  setCurrentPositionFail: function () {
    console.log("failCurrentPosition - navigator.geolocation.getCurrentPosition fail");
  }


}

module.exports = map;
