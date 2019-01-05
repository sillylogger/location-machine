





# [LocationMachine.io](https://www.locationmachine.io)

Welcome!  Location Machine is an attempt to connect GPS points with quality photos to 3rd party messaging apps.  Right now it kinda looks like this:

![Screenshot](/app/assets/images/location-machine-dot-io-mvp.png)

There are many applications for a generic app of this nature: event organization, community selling, photo blogging...

Hopefully, Location Machine can provide a toolkit of services necessary to setup other apps, supporting UI customization, with an upgradable core.
Much like [WordPress.org](https://wordpress.org/) provides a CMS for websites, blogs, and other types of apps.

How will that core / UI layer be segregated?  Likely at the JS level, but it will evolve as we spin up instances of Location Machine.



## Getting Started

These instructions will help you get a copy of the project up and running on your local machine for development and testing purposes.

See [deployment](#deployment) for notes on how to deploy Location Machine to Heroku or Google App Engine.


### Prerequisites

Right now, I am using the following tools to build and run the project:

- Ubuntu 18.04
- Git 2.17.1
- PostgreSQL 9.6.11
- Ruby 2.5.1
- Bundler 1.16.2
- Yarn 1.12.3

You can likely run the project with other versions of that software, it just hasn't been tested yet.
OS X will be supported at somepoint in the future.  Windows, fuhgeddaboudit!


### Installing

Checkout and install dependencies:
```
git clone git@github.com:sillylogger/location-machine.git
cd location-machine
bundle install
yarn install
```

### Credentials

Rails 5.2 provides [a great way](https://edgeguides.rubyonrails.org/security.html#environmental-security) to manage those credentials, but it isn't designed to support several installs of the same app.

We have created an interface for `Rails.application.credentials` that allows for credentials to be overridden with plain old `ENV` variables.

`Setting.fetch_credential('facebook', 'app_id')` will return `ENV['facebook_app_id']` if set, otherwise it will look up `Rails.application.credentials.facebook[:app_id]`.

You can find an unencrypted example credentials file at `config/credentials.yml.example`

Copy this structure into `rails credentials:edit` to utilize your own encrypted config file.

A basic install of Location Machine needs the following credentials:

```
secret_key_base:

google:
  maps_api_key:
  tracking_id:

facebook:
  app_id:
  app_secret:

cloudinary:
  cloud_name:
  api_key:
  api_secret:
```

Additional credentials are explained in [3rd Party Services](#3rd-party-services)


### Running the app

Create the database and some sample data:

```
rails db:create
rails db:migrate
rails db:seed
```

You can then start the project with:
```
rails s
```

If everything worked all right, you should be able to visit the app at `http://localhost:3000` and login with the seed data: `admin@example.com` / `password`

**Yayyyy!**  As admin you can also modify settings at `http://localhost:3000/admin`

In order to login via Facebook's OAuth, you are going to need to use SSL locally.

That can be accomplished with:

```
puma -b 'ssl://127.0.0.1:3000?key=config/localhost.key&cert=config/localhost.crt'
```

Make sure your Facebook App's Client OAuth Settings specify Valid OAuth Redirect URIs like `https://localhost:3000/users/auth/facebook/callback`


### Running the tests

Setup your test database with:

```
bundle exec rails db:test:prepare
```

Then you should be able to run:

```
bundle exec rspec spec
```



## Deployment

**TODO:** add a 0-to-Heroku deployment here



## Backlog

The product and development roadmap is maintained in [PivotalTracker](https://www.pivotaltracker.com/n/projects/2230844)



## 3rd Party Services

Don't build what you can buy.  As such, we rely on 3rd party services for:

| Service          | Currently Supported                                                                                  | Monthly Cost                | Development Roadmap                 |
|------------------|------------------------------------------------------------------------------------------------------|-----------------------------|-------------------------------------|
| Hosting          | [Google App Engine](https://cloud.google.com/appengine/)                                             | ~ $60                       | - [Heroku](https://www.heroku.com/) |
| Maps             | [Google Maps](https://developers.google.com/maps/documentation/javascript/tutorial)                  | free, for current usage     | |
| Analytics        | [Google Analytics](https://developers.google.com/analytics/devguides/collection/gtagjs/)             | free, for current usage     | |
| Auth             | [OAuth w/ facebook](https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow) | free                        | - Phone Number w/ [Authy](https://www.twilio.com/authy) <br/> - [OAuth w/ Google](https://developers.google.com/identity/protocols/OAuth2) |
| Image Processing | [Cloudinary](https://cloudinary.com/)                                                                | free, soon $89              | - [Thumbor](http://thumbor.org/)    |

These services require additional credentials.

To host image uploads, Rails [ActiveStorage](https://edgeguides.rubyonrails.org/active_storage_overview.html) can be configured to use S3, GCS, etc.  Currently the app supports `GCS` with credentials:
```
google:
  storage_service_account:
```

If deploying to Google App Engine, the [Postgres Cloud SQL](https://cloud.google.com/sql/docs/postgres/) will need credentials:
```
google:
  cloud_sql_username:
  cloud_sql_password:
  cloud_sql_connection_name:
```



<!-- ## License -->
<!--  -->
<!-- This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details -->



## Acknowledgments

* Hat tip to: [README Template](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* Inspiration: [WordPress.org](https://wordpress.org) :-)


