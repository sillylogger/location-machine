let Map = require('javascripts/map');

describe("Map", () => {

  let map_canvas;

  function mockGoogle() {
    window.google = {};

    window.google.maps = jasmine.createSpyObj('maps', [
      'InfoWindow', 'LatLng', 'Map', 'Marker', 'Size', 'Point'
    ]);

    window.google.maps.event = {
      addListener: function() {}
    };

    window.google.maps.MapTypeId = {
      ROADTYPE: 1
    };

    window.google.maps.Map.prototype.set = function(){};
  }

  beforeEach( () => {
    mockGoogle();

    map_canvas = document.createElement('div');
    map_canvas.id = "map_canvas";
    root.appendChild(map_canvas);
  });

  describe("constructor", () => {

    it("logs out if google isn't there", () => {
      window.google = false;

      spyOn(console, 'log').and.callThrough();
      var map = new Map();
      expect(console.log).toHaveBeenCalled();

      var message = console.log.calls.mostRecent().args[0];
      expect(message).toMatch(/google not loaded/);
    });

    it("logs out if the canvas isn't there", () => {
      map_canvas.parentElement.remove(map_canvas);

      spyOn(console, 'log').and.callThrough();
      var map = new Map();
      expect(console.log).toHaveBeenCalled();

      var message = console.log.calls.mostRecent().args[0];
      expect(message).toMatch(/mapCanvas isn't/);
    });

  });

});

