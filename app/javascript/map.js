let googleMap = null,
  lastMarker = null,
  lastInfoWindow = null,
  latId = null,
  lngId = null,
  currentLocationMarker = null,
  markers = [];

let mapOptions = {
  zoom: 15,
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
    window.searchQuery = '';
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
      zIndex: 2,
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

  setBounds(bounds) {
    window.bounds = bounds;
  }

  getSearchParams() {
    return new URLSearchParams({
      'bounds[south_west]': window.bounds[0],
      'bounds[north_east]': window.bounds[1],
      query: window.searchQuery,
    });
  }

  fetchLocationsAndRenderOnMap() {
    fetch(`/locations.json?${this.getSearchParams().toString()}`)
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
  }

  placeLocationsInBounds() {
    googleMap.addListener('idle', () => {
      let mapBounds = googleMap.getBounds();
      let swPoint = mapBounds.getSouthWest();
      let nePoint = mapBounds.getNorthEast();

      this.setBounds([
        [swPoint.lat(), swPoint.lng()],
        [nePoint.lat(), nePoint.lng()],
      ]);
      this.fetchLocationsAndRenderOnMap();
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

  addDraggableMarker(latLng) {
    this.destroyLastMarker();
    this.storeLatLng(latLng);
    market = this.addMarker(latLng, {draggable: true}, [
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
      console.log(`map.storeLatLng - ${position.lat()} - ${position.lng()}`);
    }
  }

  panTo(position) {
    googleMap.panTo(position);
    googleMap.setZoom(15);
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

  hydrateLatLng(latElementId, lngElementId, searchBoxId) {
    let searchBox = new google.maps.places.SearchBox(
      document.getElementById(searchBoxId),
    );

    latId = latElementId;
    lngId = lngElementId;

    searchBox.addListener('places_changed', () => {
      let places = searchBox.getPlaces();

      if (places.length == 0) return;

      let latLng = places[0].geometry.location;

      this.addDraggableMarker(latLng);
      this.panTo(latLng);
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
    let marker = this.addMarker(position, {
      title: location.name,
      id: location.id,
    });

    markers.push(marker);

    if (options.panTo) {
      this.panTo(position);
    }

    if (options.info !== false) {
      let infoWindow = this.buildLocationInfoWindow(location);
      this.setInfoWindowToMarker.bind(this)(marker, infoWindow);
    }
    return marker;
  }

  placeLocations(locations) {
    let markerIds = markers.map(marker => marker.id);
    let newLocations = locations.filter(
      location => !markerIds.includes(location.id),
    );

    let locationIds = locations.map(location => location.id);
    let keptMarkers = markers.filter(marker => locationIds.includes(marker.id));
    let outdatedMarkerIds = markers
      .filter(marker => !locationIds.includes(marker.id))
      .map(marker => marker.id);
    markers.map(marker => {
      if (outdatedMarkerIds.includes(marker.id)) {
        marker.setMap(null);
      }
    });
    markers = keptMarkers;

    // add new markers
    newLocations.forEach(this.placeLocation.bind(this));
  }

  pushCoordinate(coordinate, options) {
    fetch(`users/${options.currentUserId}/coordinates.json`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        coordinate: {
          latitude: coordinate.latitude,
          longitude: coordinate.longitude,
        },
      }),
    });
  }

  allocateUserCoordinate(options = {}) {
    if (!navigator.geolocation) {
      console.log(
        'map.allocateUserCoordinate - navigator.geolocation not available',
      );
      return false;
    }

    navigator.geolocation.getCurrentPosition(
      position => {
        this.setCurrentPositionSuccess.bind(this)(position.coords, options);
      },
      () => this.setCurrentPositionFail.bind(this)(options),
    );
  }

  convertCoordinateToLatLng(coordinate) {
    return new google.maps.LatLng(coordinate.latitude, coordinate.longitude);
  }

  pinCoordinate(coordinate) {
    this.addDraggableMarker(this.convertCoordinateToLatLng(coordinate));
  }

  setPosition(coordinate, options) {
    if (!coordinate.latitude) {
      return;
    }

    document.cookie = `latitude=${coordinate.latitude}`;
    document.cookie = `longitude=${coordinate.longitude}`;

    let latLng = this.convertCoordinateToLatLng(coordinate);

    currentLocationMarker.setPosition(latLng);
    googleMap.panTo(latLng);

    if (options.callback) {
      options.callback.bind(this)(coordinate);
    }
  }

  setCurrentPositionSuccess(coordinate, options) {
    console.log(
      `Allocate user coordinate successfully: ${coordinate.latitude}, ${
        coordinate.longitude
      }`,
    );

    if (options.currentUserId) {
      this.pushCoordinate(coordinate, options);
    }

    this.setPosition.bind(this)(coordinate, options);
  }

  setCurrentPositionFail(options) {
    if (options.latestCoordinate) {
      console.log(
        `Allocate user coordinate failed, get coordinate from history: ${
          coordinate.latitude
        }, ${coordinate.longitude}`,
      );
      this.setPosition.bind(this)(options.latestCoordinate, options);
    }
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
    controlUI.style.backgroundImage =
      'url(https://maps.gstatic.com/tactile/mylocation/mylocation-sprite-cookieless-v2-2x.png)';
    controlUI.style.backgroundPosition = '0 0';
    controlUI.style.backgroundSize = '180px 18px';
    controlButton.appendChild(controlUI);

    controlUI.addEventListener('click', e => {
      e.preventDefault();
      googleMap.panTo(currentLocationMarker.getPosition());
    });

    googleMap.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(
      controlDiv,
    );
  }
}

module.exports = Map;
