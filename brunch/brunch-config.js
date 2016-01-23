var config = {

  sourceMaps: false,

  files: {
    javascripts: {
      joinTo: {
        'pre-application.js':  'app/javascripts/**.js'
      }
    },
    stylesheets: {
      joinTo: {
        'pre-application.css': 'app/stylesheets/pre-application.scss'
      }
    }
  },

  plugins: {
    autoReload: {
      enabled: {
        css: true,
        js:  false
      }
    }
  }

};

module.exports = { config: config }

