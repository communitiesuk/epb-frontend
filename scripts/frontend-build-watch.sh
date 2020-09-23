#!/usr/bin/env bash

chsum1=""

while [[ true ]]; do
  chsum2=$(find assets/ -type f -exec md5 {} \;)
  if [[ $chsum1 != $chsum2 ]]; then
    make frontend-build
    chsum1=$chsum2
    if command -v osascript &> /dev/null; then
        osascript -e 'display notification "Frontend assets have been rebuilt!" with title "Frontend Build"'
    fi
  fi
  sleep 2
done
