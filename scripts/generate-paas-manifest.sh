#!/usr/bin/env bash

#define parameters which are passed in.
APPLICATION_NAME=$1  # e.g. epb-something-api

cat << EOF
---
applications:
- name: $APPLICATION_NAME
  memory: 64M
  buildpacks:
  - staticfile_buildpack

EOF
