# Energy Performance of Buildings Register

Frontend for the Energy Performance of Buildings Register:
<https://mhclg-epb-frontend-ui-production.london.cloudapps.digital>

## Getting Started

Make sure you have the following installed:

* [Ruby](https://www.ruby-lang.org)
  * [Bundler](https://bundler.io) to install dependencies found in `Gemfile`
* [Node Package Manager (NPM)](https://www.npmjs.com)
* [Yarn - Package Manager](https://yarnpkg.com)
* [Git](https://git-scm.com) (_optional_)

### Install

This short guide will use `Git`.

1. Clone the repository: `$ git clone git@github.com:communitiesuk/epb-frontend.git`
2. Change into the cloned repository: `$ cd epb-frontend`
3. Install the Node modules/packages: `$ yarn install`
4. Install the Ruby gems: `$ bundle install`
5. Build the frontend assets: `$ make frontend-build`

## Test

### Prerequisites

To run the Capybara user-journey tests, the following must be downloaded and
installed.

* [Chrome](https://www.google.com/chrome)
* [ChromeDriver](https://chromedriver.chromium.org/downloads)
  * download the same ChromeDriver version as your version of Chrome.

Depending on how ChromeDriver was installed, it may need to be added to the
`PATH` environment variable. Instructions below are for MacOS users.

1. Create local `bin` directory: `$ mkdir ~/bin`
2. Move the downloaded ChromeDriver to the `bin` directory:
`$ mv ~/Downloads/chromedriver ~/bin`
3. Make the ChromeDriver executable: `cd ~/bin && chmod +x chromedriver`
4. Add the `bin` directory to the `PATH` environment variable in your shell
profile:

```bash
# ~/.bash_profile, ~/.zprofile, etc

...
export PATH="$PATH:$HOME/bin" # Add this line at the end of the file
```

Run `$ source ~/.bash_profile`, or `.zprofile`. Alternatively, restart the
terminal.

5. You must add additional local hosts to your hosts file on your machine with:

```
127.0.0.1	getting-new-energy-certificate.local.gov.uk
127.0.0.1	find-energy-certificate.local.gov.uk
```

### Test suites

To run the respective test suites:

* RSpec tests: `$ make test`
* User-journey tests: `$ make journey`

## Usage

### Environment configuration

The frontend needs to authenticate and connect to the API.  The following
environment variables should be set to specify the auth server and API server to
use:

```bash
EPB_AUTH_CLIENT_ID=<client-id-that-exists-in-auth-server>
EPB_AUTH_CLIENT_SECRET=<secret-for-auth-server>
EPB_AUTH_SERVER=<url-of-auth-server>
EPB_API_URL=<url-of-epb-api>
```

### Running the frontend

1. Change directory into the root of the cloned folder: `$ cd epb-frontend`
2. Start the web server(s) using the following command: `$ make run` or
`$ make run ARGS=config_test.ru`

Open <http://localhost:9292> in your favourite browser.

## Deploy

To deploy to GOV.UK PaaS you will need to be logged in to your CloudFoundry
account, and set the correct space as target, e.g.:

```bash
cf target -o mhclg-energy-performance -s integration
```

Set the variables `APPLICATION_NAME` and `STAGE` to relevant values, e.g.:

```bash
export APPLICATION_NAME=epb-frontend-ui
export STAGE=integration
```

_Note_: The `STAGE` should generally match the name of the current CloudFoundry
space.

Run the following command to deploy the application: `$ make deploy-app`

This will:
* Check that your current target space is active
* Run the frontend build to generate assets
* Generate a manifest file suitable for the current space
* Push the local app to the target application
