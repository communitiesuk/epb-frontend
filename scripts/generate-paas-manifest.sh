#!/usr/bin/env bash

#define parameters which are passed in.
APPLICATION_NAME=$1  # e.g. epb-something-api
STAGE=$2 # i.e. [integration, staging, production]

cat << EOF
---
applications:
- name: $APPLICATION_NAME
  memory: 256M
  buildpacks:
  - ruby_buildpack
  health-check-type: http
  health-check-http-endpoint: /healthcheck
  services:
    - mhclg-epb-redis-ratelimit-$STAGE
EOF
