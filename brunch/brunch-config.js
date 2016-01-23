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
    sass: {
      mode: 'ruby'
    }
  }

};

module.exports = { config: config }

  // paths: {
  //   public: './../public/assets/'
  // },
  //
  // sourceMaps: false,
  //
  // files: {
  //   javascripts: {
  //     joinTo: {
  //       'javascripts/pre-application.js':  /javascripts\/.*\.js/
  //     },
  //   },
  //   stylesheets: {
  //     joinTo: {
  //       'stylesheets/pre-application.css': /stylesheets\/.*\.scss/
  //     }
  //   }
  // }
