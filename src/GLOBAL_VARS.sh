#!/bin/bash

# Globals are loaded using an import, hence, they do not need to be exported.
# shellcheck disable=SC2034
TORRC_JSON_FILEPATH=/etc/tor/torrc.json
# TORRC_FILEPATH=/etc/tor/torrc # Is loaded from bash-start-tor-at-boot.
