# Energy Performance of Buildings Register

Frontend for the Energy Performance of Buildings Register:

- <https://find-energy-certificate.service.gov.uk>
- <https://getting-new-energy-certificate.service.gov.uk>

[![Frontend smoke tests](https://github.com/communitiesuk/epb-frontend-smoke-tests/actions/workflows/main.yml/badge.svg)](https://github.com/communitiesuk/epb-frontend-smoke-tests/actions/workflows/main.yml)

## Getting Started

Make sure you have the following installed:

- [Ruby](https://www.ruby-lang.org)
  - [Bundler](https://bundler.io) to install dependencies found in `Gemfile`
- [Node Package Manager (NPM)](https://www.npmjs.com)
- [Git](https://git-scm.com) (_optional_)

### Install

This short guide will use `Git`.

1. Clone the repository: `$ git clone git@github.com:communitiesuk/epb-frontend.git`
2. Change into the cloned repository: `$ cd epb-frontend`
3. Install the Node modules/packages: `$ npm install`
4. Install the Ruby gems: `$ bundle install`
5. Build the frontend assets: `$ make frontend-build`

## Test

### Prerequisites

You must add additional local hosts to your hosts file on your machine with:

```
127.0.0.1	getting-new-energy-certificate.epb-frontend
127.0.0.1	find-energy-certificate.epb-frontend
127.0.0.1	getting-new-energy-certificate.local.gov.uk
127.0.0.1	find-energy-certificate.local.gov.uk
```

You can add these to your hosts file automatically by running `$ sudo make hosts`.
You can check what hosts you already have by typing `$ cat /etc/hosts` in the
frontend directory.

Don't forget to ensure bundle and npm dependencies are up to date

### Test suites

To run the respective test suites:

- All tests: `$ make test`
- User-journey tests: `$ make journey`

## Usage

### Environment configuration

The frontend needs to authenticate and connect to the API. The following
environment variables should be set to specify the auth server and API server to
use:

```bash
EPB_AUTH_CLIENT_ID=<client-id-that-exists-in-auth-server>
EPB_AUTH_CLIENT_SECRET=<secret-for-auth-server>
EPB_AUTH_SERVER=<url-of-auth-server>
EPB_API_URL=<url-of-epb-api>
```

### Running the frontend

#### The test stubs server

1. To run the test stubs server (i.e. the frontend in isolation from the local API),
   change directory into the root of the cloned folder: `$ cd epb-frontend`
2. Start the web server(s) using the following command: `$ make run` or
   `$ make run ARGS=config_test.ru`
3. Open <http://getting-new-energy-certificate.epb-frontend:9292> or
   <http://find-energy-certificate.epb-frontend:9292> in your favourite browser to
   run the test stubs server.

#### The integrated server

1. To run the local frontend alongside your local API in Docker, make sure that
   the Docker images from the epb-dev-tools repo are running
2. Then access the frontend at <http://getting-new-energy-certificate.epb-frontend>
   or <http://find-energy-certificate.epb-frontend> (without the specified ports).

## Docker image

### Build

To rebuild the Docker image locally, run

`docker build . --tag epb-frontend`

### Run

#### Docker Desktop

You can run the created image in Docker Desktop by going to **Images** and pressing **Run** in the _Actions_ column.
This will create a persistent deployment and has an interface to provide multiple useful options.

#### CLI

To run the docker image with CLI

`docker run -p 80:80 -p 443:443 --name test-epb-frontend epb-frontend`

If you want docker to communicate with a containerized instance of PostgreSQL, or another container in general,
you will need to use a bridge network and connect any containers that need to communicate with each other to it

You can set up a bridge network using
`docker network create {network_name}`

And then connect the containers to the network when going to run them e.g.

`docker run -p 80:80 -p 443:443 --network {network_name} --name test-epb-frontend epb-frontend`

#### Hosts file

When running the container, you may find that `http://localhost` and
other frontend pages such as `http://localhost/find-an-assessor/type-of-property`
all redirect and show the **Page not found** page

Add the following line to your hosts file (/etc/hosts for macOS and most linux distros):
`127.0.0.1 getting-new-energy-certificate.epb-frontend find-energy-certificate.epb-frontend getting-new-energy-certificate.local.gov.uk find-energy-certificate.local.gov.uk epb-frontend epb-register-api epb-auth-server epb-feature-flag`

You then should be able to access the locally deployed website via `http://find-energy-certificate.epb-frontend/` and `http://getting-new-energy-certificate.epb-frontend/`

## Environmental variables

#### `APP_ENV`

Set the [Sintra environment](https://sinatrarb.com/intro.html#environments).
Should be one of "production", "development" or "test".

Sinatra will fallback to `RACK_ENV` or "development" if unset.

#### `RACK_ENV`

Used by rackup to choose the [default middleware stack](https://github.com/rack/rackup/blob/f3fa1d6ada90e9e7aa1f712488ddde87ea2a2075/lib/rackup/server.rb#L273).
Should be one of "development" (default) or "deployment". If set to any other value no middleware stack is loaded.

#### `STAGE`

The EPB environment. Can be one of "test", "development", "integration", "staging" or "production".

- Sets the unleash feature flag service app name to `toggles-#{stage}`
- When "test", configures exceptions and enabled Capybara lock-step
- When "test", disables directing to the service start for intermediate pages on forms
- Unless "development" or "test", enables Sentry and sets its environment value
- Unless "production", sets the tag used in the phase banner

#### `ASSETS_VERSION`

The value of the cache busting prefix used for serving assets.

This is a random number generated for each production build by `make assets-version` and saved to an `./ASSETS_VERSION` file.

Do not set this for local development.

#### `EPB_API_URL`

The URL of the register API.

#### `EPB_DATA_WAREHOUSE_API_URL`

The URL of the data warehouse API.

#### `EPB_AUTH_CLIENT_ID`

The client id for connecting to the API services.

#### `EPB_AUTH_CLIENT_SECRET`

The client secret for connecting to the API services.

#### `EPB_AUTH_SERVER`

The URL of the auth server for connecting to the register API.

#### `EPB_RECAPTCHA_SITE_KEY`

The key for the Google Recaptcha service.

#### `EPB_RECAPTCHA_SITE_SECRET`

The secret for the Google Recaptcha service.

#### `EPB_SUSPECTED_BOT_USER_AGENTS`

A JSON formatted array of strings containing a list of user-agent strings that should be presented with a recaptcha.

#### `EPB_UNLEASH_URI`

The URL of the unleash feature flag service.

#### `EPB_UNLEASH_AUTH_TOKEN`

Authentication token for the unleash feature flag service.

#### `GTM_PROPERTY_FINDING`

The Google tag manager container id used to load Google Analytics for the "Find an energy certificate" service.

This is selected if the host domain starts with "find"

#### `GTM_PROPERTY_GETTING`

The Google tag manager container id used to load Google Analytics for the "Get a new energy certificate" service.

This is selected if the host domain does not start with "find"

#### `SCRIPT_NONCE`

The nonce used by the Content-Security-Policy to protect against XSS attacks.

#### `STATIC_START_PAGE_FINDING_CY`

URL of the gov.uk hosted start page for the [Welsh "Find an energy certificate" service](https://www.gov.uk/dod-o-hyd-i-dystysgrif-ynni)

This is selected if the host domain name starts with "find" and the language is "cy".

#### `STATIC_START_PAGE_FINDING_EN`

URL of the gov.uk hosted start page for the [English "Find an energy certificate" service](https://www.gov.uk/find-energy-certificate)

This is selected if the host domain name starts with "find" and the language is not "cy".

#### `STATIC_START_PAGE_GETTING_CY`

URL of the gov.uk hosted start page for the [Welsh "Get a new energy certificate" service](https://www.gov.uk/cael-tystysgrif-ynni-newydd)

This is selected if the host domain name does not start with "find" and the language is "cy".

#### `STATIC_START_PAGE_GETTING_EN`

URL of the gov.uk hosted start page for the [English "Get a new energy certificate" service](https://www.gov.uk/get-new-energy-certificate)

This is selected if the host domain name does not start with "find" and the language is not "cy".

#### `SUPPRESS_REDIRECT_TO_SERVICE_START`

If "true", prevents the user being redirected back to the gov.uk hosted service start page when following
a deep-link from a third party website to an intermediary page.
