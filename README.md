# Energy Performance of Buildings Register
Frontend for the Energy Performance of Buildings Register.

## Install

Follow the steps below to get started.

1. make sure you have Node Package Manager (NPM) installed
2. clone the repository - `$ git clone git@github.com:communitiesuk/epb-frontend.git`
3. change into the cloned repository - `$ cd epb-frontend`
4. install the node modules/packages - `$ npm install`

## Start

Change directory into the root of the cloned folder:

`$ cd epb-frontend`

Start the web server using the following command:

`$ npm run start`

Open `http://localhost` in your favourite browser.

## Deploy

To deploy to GOV.UK PaaS you will need to be logged in to your CloudFoundry account, and set the correct space as target, e.g.:
```bash
cf target -o mhclg-energy-performance -s integration
```

Set the variables `APPLICATION_NAME` and `STAGE` to relevant values, e.g.
```bash
export APPLICATION_NAME=epb-frontend-ui 
export STAGE=integration 
```
(The `STAGE` should generally match the name of the current CloudFoundry space.)

Then run 
```bash
make deploy-app
```

This will:
* Check that your current target space is active
* Run the frontend build to generate assets
* Generate a manifest file suitable for the current space
* Push the local app to the target application
