#!/bin/bash

# Copyright 2020 Akamai Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Fail fast
set -e

# Required arguments
export DOCKER_NAME="${DOCKER_NAME:?DOCKER_NAME must be set}"
export DOCKER_USERNAME="${DOCKER_USERNAME:?DOCKER_USERNAME must be set}"
export DOCKER_PASSWORD="${DOCKER_PASSWORD:?DOCKER_PASSWORD must be set}"

# Override to use a different registry
export DOCKER_REGISTRY="${DOCKER_REGISTRY}"

# Override to use a different Dockerfile
export DOCKER_DOCKERFILE="Dockerfile"
# Override to use a different docker path
export DOCKER_PATH="."

# Define the tag, use reasonable defaults:
# - local build : provide DOCKER_TAG explicitly, will default to "latest"
# - travis push, api, pull requestion : will default to latest unless overridden in .travis.yml
# - travis cron : will default to timestamp unless overridden in .travis.yml
guess_tag() {
  case "$TRAVIS_EVENT_TYPE" in
    cron) date -u +"%Y%m%d%H00";;
    push) echo latest;;
    api) echo latest;;
    *) echo latest;;
  esac
}
export DOCKER_TAG="${DOCKER_TAG:-$(guess_tag)}"

# Build-time labels
# http://label-schema.org/rc1/
export LABEL_BUILD_DATE="${LABEL_BUILD_DATE:-$(date -u +"%Y-%m-%dT%H:%M:%SZ")}"
export LABEL_NAME="${LABEL_NAME:-${DOCKER_NAME}}"
export LABEL_URL="${LABEL_URL:-https://developer.akamai.com}"
export LABEL_VENDOR="${LABEL_VENDOR:-Akamai Technologies}"
export LABEL_VCS_URL="${LABEL_VCS_URL:-$(git remote get-url origin)}"
export LABEL_VCS_REF="${LABEL_VCS_REF:-$(git rev-parse --short HEAD)}"
