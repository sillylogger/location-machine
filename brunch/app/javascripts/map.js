
let map = null,
    lastMarker = null,
    lastInfoWindow = null;

class Map {

  constructor() {
    if(!window.google) {
      console.log("map.init - google not loaded");
      return false;
    }

    let canvas = document.getElementById('map_canvas');
    if(!canvas) {
      console.log("initializeMap - mapCanvas isn't on this page");
      return false;
    }

    let jakarta = new google.maps.LatLng(-6.1745, 106.8227);

    let mapOptions = {
        center: jakarta,
        zoom: 8,
        scrollwheel: true,
        draggable: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    map = new google.maps.Map(canvas, mapOptions);

    map.set('styles', [{
      featureType: 'landscape',
      elementType: 'geometry',
      stylers: [
        { hue: '#ffff00' },
        { saturation: 30 },
        { lightness: 10 }
      ]}
    ]);
  }

  isInitialized() {
    return map != undefined;
  }

  hydrateLatLng(latId, lngId) {
    let lattitudeInput = document.getElementById(latId);
    let longitudeInput = document.getElementById(lngId);

    map.addListener('click', e => {

      if(lastMarker) {
        lastMarker.setMap(null);
      }

      let marker = new google.maps.Marker({
        position: e.latLng,
        map: map
      });

      lattitudeInput.value = e.latLng.lat();
      longitudeInput.value = e.latLng.lng();

      lastMarker = marker;
    });
  }

  placeEvents(events) {
    events.forEach( e => {
      let eventLocation = new google.maps.LatLng(e.latitude, e.longitude);

      let marker = new google.maps.Marker({
        position: eventLocation,
        map: map,
        title: e.name
      });

      google.maps.event.addListener(marker, 'click', () => {
        if(lastInfoWindow != null) {
          lastInfoWindow.close();
        }

        let infoWindow = new google.maps.InfoWindow({
          content: e.name,
          maxWidth: 300
        });

        infoWindow.open(map, marker);

        lastInfoWindow = infoWindow;
      });
    });
  }

  setCurrentPosition() {
    if(!navigator.geolocation) {
      console.log("ready - navigator.geolocation not available");
      return false;
    }

    navigator.geolocation.getCurrentPosition(
      this.setCurrentPositionSuccess.bind(this),
      this.setCurrentPositionFail.bind(this)
    );
  }

  setCurrentPositionSuccess(position) {
    console.log("setCurrentPosition - navigator.geolocation.getCurrentPosition success");
    if(!position.coords) { return; }

    let currentLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

    let marker = new google.maps.Marker({
      position: currentLocation,
      map: map,

      'clickable': false,
      'cursor': 'pointer',
      'draggable': false,
      'flat': true,
      'icon': {
        'url':        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABHNCSVQICAgIfAhkiAAAAF96VFh0UmF3IHByb2ZpbGUgdHlwZSBBUFAxAABo3uNKT81LLcpMVigoyk/LzEnlUgADYxMuE0sTS6NEAwMDCwMIMDQwMDYEkkZAtjlUKNEABZgamFmaGZsZmgMxiM8FAEi2FMnxHlGkAAADqElEQVRo3t1aTWgTQRQOiuDPQfHs38GDogc1BwVtQxM9xIMexIN4EWw9iAehuQdq0zb+IYhglFovClXQU+uhIuqh3hQll3iwpyjG38Zkt5uffc4XnHaSbpLZ3dnEZOBB2H3z3jeZN+9vx+fzYPgTtCoQpdVHrtA6EH7jme+/HFFawQBu6BnWNwdGjB2BWH5P32jeb0V4B54KL5uDuW3D7Y/S2uCwvrUR4GaEuZABWS0FHhhd2O4UdN3FMJneLoRtN7Y+GMvvUw2eE2RDh3LTOnCd1vQN5XZ5BXwZMV3QqQT84TFa3zuU39sy8P8IOqHb3T8fpY1emoyMSQGDI/Bwc+0ELy6i4nLtepp2mE0jc5L3UAhMsdxut0rPJfRDN2eMY1enF8Inbmj7XbtZhunkI1rZFD/cmFMlr1PFi1/nzSdGkT5RzcAzvAOPU/kVF9s0ujqw+9mP5QgDmCbJAV7McXIeGpqS3Qg7OVs4lTfMD1Yg9QLR518mZbImFcvWC8FcyLAbsev++3YETb0tn2XAvouAvjGwd14YdCahUTCWW6QQIzzDO/CIAzKm3pf77ei23AUkVbICHr8pnDZNynMQJfYPT7wyKBzPVQG3IvCAtyTsCmRBprQpMawWnkc+q2Rbn+TK/+gmRR7qTYHXEuZkdVM0p6SdLLYqX0LItnFgBxe3v0R04b5mGzwnzIUMPiBbFkdVmhGIa5tkJ4reZvyl4Rg8p3tMBh+FEqUduVRUSTKTnieL58UDG76cc70AyMgIBxs6pMyIYV5agKT9f/ltTnJFOIhuwXOCLD6gQ/oc8AJcdtuYb09xRQN3NWULgCwhfqSk3SkaBZViRTK3EYNUSBF4Hic0Y8mM+if0HhlMlaIHbQ8Z5lszxnGuIP2zrAw8J8jkA7pkMAG79AKuPTOOcgWZeVP5AsSDjAxWegGyJoSUWAj/FBpRa0JiviSbfldMqOMPcce7UVeBLK4gkMVVBLI2phLjKlIJm8lcxMNkLuIomXOTTmc1kwYf2E+nMQdzlaTTKgoaZJWyBQ141RY0DkrK6XflAQbih1geZnhJeXu5WeEZ3mVqSkrIgCzXJaXqoh65TUuLerdtFXgQ2bYKeD1pq6hobLE86SlztXMWvaA5vPO0sYWB9p2K1iJS4ra0Fju/udsN7fWu+MDRFZ+YuuIjX1d8Zu2OD92WC9G3ub1qABktBV7vssfBMX1L7yVjZ7PLHuABb9svezS7boNDyK/b4LdX123+Au+jOmNxrkG0AAAAAElFTkSuQmCC',
        'size':       new google.maps.Size(48, 48),
        'scaledSize': new google.maps.Size(24, 24),
        'origin':     new google.maps.Point(0, 0),
        'anchor':     new google.maps.Point(8, 8)
       },

       // This marker may move frequently - don't force canvas tile redraw
       'optimized': false,
       'title': 'Current location',
       'zIndex': 2
    });

    map.panTo(marker.getPosition());
    map.setZoom(12);
  }

  setCurrentPositionFail() {
    console.log("failCurrentPosition - navigator.geolocation.getCurrentPosition fail");
  }

}

module.exports = Map;

