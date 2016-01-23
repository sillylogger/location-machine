var config = {

  sourceMaps: false,

  files: {
    javascripts: {
      joinTo: {
        'javascripts/pre-application.js':  'app/javascripts/**.js'
      }
    },
    stylesheets: {
      joinTo: {
        'stylesheets/pre-application.css': 'app/stylesheets/pre-application.scss'
      }
    }
  },

  paths: {
    public: './../public/assets/'
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

