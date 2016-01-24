var config = {

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
    babel: {
      presets: [ 'es2015' ]
    },

    autoReload: {
      enabled: {
        css: true,
        js:  false
      }
    }
  }

};

module.exports = { config: config }

