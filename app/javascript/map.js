let googleMap = null,
  lastMarker = null,
  lastInfoWindow = null,
  latId = null,
  lngId = null,
  currentLocationMarker = null,
  bounds = null,
  markers = [];

let mapOptions = {
  zoom: 10,
  draggable: true,
  scrollwheel: true,

  mapTypeId: google.maps.MapTypeId.ROADMAP,
  mapTypeControl: false,
  fullscreenControl: true,
  streetViewControl: false,
  zoomControl: false,

  clickableIcons: false,
  styles: [
    {
      elementType: 'geometry',
      featureType: 'landscape',
      stylers: [{hue: '#ffff00'}, {saturation: 30}, {lightness: 10}],
    },
  ],
};

class Map {
  constructor(rawCenterString) {
    if (!window.google) {
      console.log('map.constructor - google not loaded');
      return false;
    }

    if (googleMap !== null) {
      console.log('map.constructor - googleMap already initialized');
      return false;
    }

    let canvas = document.getElementById('map_canvas');
    if (!canvas) {
      console.log("map.constructor - mapCanvas isn't on this page");
      return false;
    }

    if (!rawCenterString) {
      rawCenterString = '-6.1745, 106.8227';
    }
    let center = rawCenterString.split(',').map(f => {
      return parseFloat(f);
    });
    mapOptions.center = new google.maps.LatLng(center[0], center[1]);

    bounds = new google.maps.LatLngBounds();

    googleMap = new google.maps.Map(canvas, mapOptions);

    currentLocationMarker = new google.maps.Marker({
      map: googleMap,
      animation: google.maps.Animation.DROP,
      clickable: false,
      cursor: 'pointer',
      draggable: false,
      flat: true,
      icon: {
        url:
          'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABHNCSVQICAgIfAhkiAAAAF96VFh0UmF3IHByb2ZpbGUgdHlwZSBBUFAxAABo3uNKT81LLcpMVigoyk/LzEnlUgADYxMuE0sTS6NEAwMDCwMIMDQwMDYEkkZAtjlUKNEABZgamFmaGZsZmgMxiM8FAEi2FMnxHlGkAAADqElEQVRo3t1aTWgTQRQOiuDPQfHs38GDogc1BwVtQxM9xIMexIN4EWw9iAehuQdq0zb+IYhglFovClXQU+uhIuqh3hQll3iwpyjG38Zkt5uffc4XnHaSbpLZ3dnEZOBB2H3z3jeZN+9vx+fzYPgTtCoQpdVHrtA6EH7jme+/HFFawQBu6BnWNwdGjB2BWH5P32jeb0V4B54KL5uDuW3D7Y/S2uCwvrUR4GaEuZABWS0FHhhd2O4UdN3FMJneLoRtN7Y+GMvvUw2eE2RDh3LTOnCd1vQN5XZ5BXwZMV3QqQT84TFa3zuU39sy8P8IOqHb3T8fpY1emoyMSQGDI/Bwc+0ELy6i4nLtepp2mE0jc5L3UAhMsdxut0rPJfRDN2eMY1enF8Inbmj7XbtZhunkI1rZFD/cmFMlr1PFi1/nzSdGkT5RzcAzvAOPU/kVF9s0ujqw+9mP5QgDmCbJAV7McXIeGpqS3Qg7OVs4lTfMD1Yg9QLR518mZbImFcvWC8FcyLAbsev++3YETb0tn2XAvouAvjGwd14YdCahUTCWW6QQIzzDO/CIAzKm3pf77ei23AUkVbICHr8pnDZNynMQJfYPT7wyKBzPVQG3IvCAtyTsCmRBprQpMawWnkc+q2Rbn+TK/+gmRR7qTYHXEuZkdVM0p6SdLLYqX0LItnFgBxe3v0R04b5mGzwnzIUMPiBbFkdVmhGIa5tkJ4reZvyl4Rg8p3tMBh+FEqUduVRUSTKTnieL58UDG76cc70AyMgIBxs6pMyIYV5agKT9f/ltTnJFOIhuwXOCLD6gQ/oc8AJcdtuYb09xRQN3NWULgCwhfqSk3SkaBZViRTK3EYNUSBF4Hic0Y8mM+if0HhlMlaIHbQ8Z5lszxnGuIP2zrAw8J8jkA7pkMAG79AKuPTOOcgWZeVP5AsSDjAxWegGyJoSUWAj/FBpRa0JiviSbfldMqOMPcce7UVeBLK4gkMVVBLI2phLjKlIJm8lcxMNkLuIomXOTTmc1kwYf2E+nMQdzlaTTKgoaZJWyBQ141RY0DkrK6XflAQbih1geZnhJeXu5WeEZ3mVqSkrIgCzXJaXqoh65TUuLerdtFXgQ2bYKeD1pq6hobLE86SlztXMWvaA5vPO0sYWB9p2K1iJS4ra0Fju/udsN7fWu+MDRFZ+YuuIjX1d8Zu2OD92WC9G3ub1qABktBV7vssfBMX1L7yVjZ7PLHuABb9svezS7boNDyK/b4LdX123+Au+jOmNxrkG0AAAAAElFTkSuQmCC',
        size: new google.maps.Size(48, 48),
        scaledSize: new google.maps.Size(24, 24),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(8, 8),
      },
      optimized: false,
      title: 'Current location',
      zIndex: 2
    });
  }

  isInitialized() {
    return googleMap != undefined;
  }

  destroyLastMarker() {
    if (lastMarker) {
      lastMarker.setMap(null);
    }
  }

  placeLocationsInBounds() {
    setTimeout(() => {
      googleMap.fitBounds(bounds);
    }, 2000);

    googleMap.addListener('idle', () => {
      this.clearMarkers();
      let mapBounds = googleMap.getBounds();
      let swPoint = mapBounds.getSouthWest();
      let nePoint = mapBounds.getNorthEast();

      let params = new URLSearchParams({
        "search_in_bounds[sw_lat]": swPoint.lat(),
        "search_in_bounds[sw_lng]": swPoint.lng(),
        "search_in_bounds[ne_lat]": nePoint.lat(),
        "search_in_bounds[ne_lng]": nePoint.lng(),
      });

      fetch(`/locations.json?${params.toString()}`)
        .then(response => {
          if (!response.ok) {
            throw Error(response.statusText);
          }
          return response.json();
        })
        .then(responseAsJson => {
          this.placeLocations(responseAsJson);
        })
        .catch(err => {
          console.log('Fetch Error: ', err);
        });
    });
  }

  setLastMarker(marker) {
    lastMarker = marker;
    console.log(
      `map.setLastMarker - ${marker.position.lat()} - ${marker.position.lng()}`,
    );
  }

  closeLastInfoWindow() {
    if (lastInfoWindow != null) {
      lastInfoWindow.close();
    }
  }

  setLastInforWindow(infoWindow) {
    lastInfoWindow = infoWindow;
  }

  addMarker(position, options = {}, callbacks = []) {
    marker = new google.maps.Marker({
      position: position,
      map: googleMap,
      ...options,
    });
    if (callbacks.length > 0) {
      callbacks.forEach(({event, callback}) => {
        marker.addListener(event, callback);
      });
    }
    return marker;
  }

  addDraggableMarker(position) {
    this.destroyLastMarker();
    this.storeLatLng(position);
    market = this.addMarker(position, {draggable: true}, [
      {
        event: 'dragend',
        callback: e => {
          this.storeLatLng(e.latLng);
        },
      },
    ]);
    this.setLastMarker(marker);
    return marker;
  }

  storeLatLng(position) {
    if (latId && lngId) {
      document.getElementById(latId).value = position.lat();
      document.getElementById(lngId).value = position.lng();
      console.log(
        `map.storeLatLng - ${position.lat()} - ${position.lng()}`,
      );
    }
  }

  panTo(position) {
    googleMap.panTo(position);
    googleMap.setZoom(17);
  }

  buildLocationInfoWindow(location) {
    let images = location.items
      .filter(i => {
        return i.image_urls != null;
      })
      .map(i => {
        return `<figure class="map-info__image">
                   <img src="${i.image_urls['thumb']}"
                        alt="${i.name}" />
                </figure>`;
      })
      .join(' ');

    return new google.maps.InfoWindow({
      content: `<div class="map-info">
        <a href="${location.pretty_path}">
          <h1 class="map-info__name">${location.name}</h1>
          <div class="map-info__images">${images}</div>
        </a>
      </div>`,
    });
  }

  setInfoWindowToMarker(marker, infoWindow) {
    marker.addListener('click', () => {
      this.closeLastInfoWindow();
      this.setLastInforWindow(infoWindow);
      lastInfoWindow.open(googleMap, marker);
    });

    return marker;
  }

  hydrateLatLng(latElementId, lngElementId) {
    latId = latElementId;
    lngId = lngElementId;
    googleMap.addListener('click', e => {
      this.addDraggableMarker(e.latLng);
    });
  }

  placeClearableLocation(location) {
    this.setLastMarker(this.placeLocation(location));
  }

  placeLocation(location, options = {}) {
    let position = new google.maps.LatLng(
      location.latitude,
      location.longitude,
    );
    let marker = this.addMarker(position, {title: location.name});

    markers.push(marker);
    bounds.extend(marker.getPosition());

    if (options.panTo) {
      this.panTo(position);
    }

    if (options.info !== false) {
      let infoWindow = this.buildLocationInfoWindow(location);
      this.setInfoWindowToMarker.bind(this)(marker, infoWindow);
    }
    return marker;
  }

  placeLocations(mapLocations) {
    mapLocations.forEach(this.placeLocation.bind(this));
  }

  setCurrentPosition(options) {
    if (!navigator.geolocation) {
      console.log('map.setCurrentPosition - navigator.geolocation not available');
      return false;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.setCurrentPositionSuccess.bind(this)(position, options);
      },
      this.setCurrentPositionFail.bind(this),
    );
  }

  setCurrentPositionSuccess(position, options = {newLocation: false}) {
    console.log(
      'map.setCurrentPositionSuccess - success',
    );

    if (!position.coords) {
      return;
    }

    let currentLocation = new google.maps.LatLng(
      position.coords.latitude,
      position.coords.longitude,
    );

    if (options.newLocation) {
      this.addDraggableMarker(currentLocation);
    }

    currentLocationMarker.setPosition(currentLocation);
    bounds.extend(currentLocation);
    googleMap.panTo(currentLocation);
    googleMap.setZoom(12);
  }

  setCurrentPositionFail() {
    console.log(
      'map.setCurrentPositionFail - fail',
    );
  }

  addLocationButton() {
    let controlDiv = document.createElement('div');
    controlDiv.index = 1;

    let controlButton = document.createElement('button');
    controlButton.title = 'Your Location';
    controlButton.style.backgroundColor = 'rgba(255,255,255,1)';
    controlButton.style.border = '0';
    controlButton.style.borderRadius = '2px';
    controlButton.style.width = '29px';
    controlButton.style.height = '29px';
    controlButton.style.boxShadow = '0 1px 4px rgba(0,0,0,0.3)';
    controlButton.style.cursor = 'pointer';
    controlButton.style.marginRight = '10px';
    controlButton.style.padding = '0';
    controlButton.style.position = 'relative';
    controlDiv.appendChild(controlButton);

    let controlUI = document.createElement('div');
    controlUI.style.position = 'absolute';
    controlUI.style.height = '18px';
    controlUI.style.left = '6px';
    controlUI.style.margin = '0';
    controlUI.style.padding = '0';
    controlUI.style.top = '6px';
    controlUI.style.width = '18px';
    controlUI.style.backgroundImage = 'url(https://maps.gstatic.com/tactile/mylocation/mylocation-sprite-cookieless-v2-2x.png)';
    controlUI.style.backgroundPosition = '0 0';
    controlUI.style.backgroundSize = '180px 18px';
    controlButton.appendChild(controlUI);

    controlUI.addEventListener('click', () => {
      googleMap.panTo(currentLocationMarker.getPosition());
    });

    googleMap.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(controlDiv);
  }

  clearMarkers() {
    for (let i = 0, ii = markers.length; i < ii; i++) {
      markers[i].setMap(null);
    }
    markers = [];
  }
}

module.exports = Map;
