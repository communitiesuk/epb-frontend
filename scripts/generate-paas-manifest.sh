#!/usr/bin/env bash

#define parameters which are passed in.
APPLICATION_NAME=$1  # e.g. epb-something-api

cat << EOF
---
applications:
- name: $APPLICATION_NAME
  memory: 1G
  buildpacks:
  - ruby_buildpack
  health-check-type: http
  health-check-http-endpoint: /healthcheck
EOF
