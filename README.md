## [LocationMachine.io](https://www.locationmachine.io)

Prototype of a simple / temporary event sharing app:  
![Screenshot](/app/assets/images/location-machine-dot-io-mvp.png)

Start the server with:
    puma -b 'ssl://127.0.0.1:3000?key=config/localhost.key&cert=config/localhost.crt'
This is because Facebook will no longer accept http endpoints, comitting
localhost keys just for dev.

### Development Goals:

Create an API that can be easily hosted on Heroku / Google App Engine.
For now, this app will serve the UI elements (thanks Rails' Webpacker), but
it would be better if the UI and API could be deployed independently :-/

Individual project stories are in [PivotalTracker](https://www.pivotaltracker.com/n/projects/2230844)

