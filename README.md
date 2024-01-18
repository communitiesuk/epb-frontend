# Energy Performance of Buildings Register

Frontend for the Energy Performance of Buildings Register:

* <https://find-energy-certificate.service.gov.uk>
* <https://getting-new-energy-certificate.service.gov.uk>

[![Frontend smoke tests](https://github.com/communitiesuk/epb-frontend-smoke-tests/actions/workflows/main.yml/badge.svg)](https://github.com/communitiesuk/epb-frontend-smoke-tests/actions/workflows/main.yml)

## Getting Started

Make sure you have the following installed:

* [Ruby](https://www.ruby-lang.org)
  * [Bundler](https://bundler.io) to install dependencies found in `Gemfile`
* [Node Package Manager (NPM)](https://www.npmjs.com)
* [Git](https://git-scm.com) (_optional_)

### Install

This short guide will use `Git`.

1. Clone the repository: `$ git clone git@github.com:communitiesuk/epb-frontend.git`
2. Change into the cloned repository: `$ cd epb-frontend`
3. Install the Node modules/packages: `$ npm install`
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

* All tests: `$ make test`
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

You can run the created image in Docker Desktop by going to **Images** and pressing **Run** in the *Actions* column.
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
