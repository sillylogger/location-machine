## [RuangBawah.com](http://www.ruangbawah.com)

Prototype of a simple / temporary event sharing app:
![Screenshot](/app/assets/images/ruangbawah-dot-com.png)

Start the server with:
    puma -b 'ssl://127.0.0.1:3000?key=config/localhost.key&cert=config/localhost.crt'
This is because Facebook will no longer accept http endpoints, comitting localhost keys just for dev.

### Development Goals:

- An asset build too other than Rail's asset pipeline.  So far I've tried:
  + grunt
  + gulp
  + [__brunch__](http://brunch.io/)
- Live reloading css * js for development
- ES6 with Jasmine tests written in ES6
- React.js


