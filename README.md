## [LocationMachine.io](https://www.locationmachine.io)

Prototype of a simple / temporary event sharing app:
![Screenshot](/app/assets/images/location-machine-dot-io-mvp.png)

Start the server with:
    puma -b 'ssl://127.0.0.1:3000?key=config/localhost.key&cert=config/localhost.crt'
This is because Facebook will no longer accept http endpoints, comitting
localhost keys just for dev.

### Development Goals:

<del>
- An asset build too other than Rail's asset pipeline.  So far I've tried:
  + grunt
  + gulp
  + [__brunch__](http://brunch.io/)
- Live reloading css * js for development
- ES6 with Jasmine tests written in ES6
- React.js
</del>

Create an API that can be easily hosted on Heroku / Google App Engine.
For now, this app will serve the UI elements (thanks Rails' Webpacker), but
it would be better if the UI and API could be deployed independently :-/


