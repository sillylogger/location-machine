var config = {

  npm: {
    enabled: true
  },

  files: {
    javascripts: {
      joinTo: {
        'assets/javascripts/pre-application.js': [
          'app/javascripts/**/**.js',
          'app/javascripts/**.js'
        ],
        'specs.js': [
          'app/javascripts/**/**.js',
          'app/javascripts/**.js',
          'app/spec/**/**.js',
          'app/spec/**.js'
        ]
      }
    },
    stylesheets: {
      joinTo: {
        'assets/stylesheets/pre-application.css': 'app/stylesheets/pre-application.scss'
      }
    }
  },

  paths: {
    public: './../public/'
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

