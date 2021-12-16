#!/usr/bin/env bash

#define parameters which are passed in.
APPLICATION_NAME=$1  # e.g. epb-something-api
STAGE=$2 # i.e. [integration, staging, production]

case "$STAGE" in
 production) MEMORY="1G" ;;
 *) MEMORY="256M" ;;
esac

cat << EOF
---
applications:
- name: $APPLICATION_NAME
  memory: $MEMORY
  buildpacks:
  - ruby_buildpack
  health-check-type: http
  health-check-http-endpoint: /healthcheck
  services:
    - mhclg-epb-redis-ratelimit-$STAGE
    - dluhc-scale-frontend-ui-$STAGE
EOF
