#!/usr/bin/env bash

# Remove the submodules if they were still in the repo.
git rm --cached test/libs/bats
git rm --cached test/libs/bats-support
git rm --cached test/libs/bats-assert
git rm --cached dependencies/bash-package-installer
git rm --cached dependencies/bash-log

# Remove and re-create the submodule directory.
rm -r test/libs
mkdir -p test/libs

# Remove and create a directory for the dependencies.
rm -r dependencies
mkdir -p dependencies

# (Re) add the BATS submodules to this repository.
git submodule add --force https://github.com/sstephenson/bats test/libs/bats
git submodule add --force https://github.com/ztombol/bats-support test/libs/bats-support
git submodule add --force https://github.com/ztombol/bats-assert test/libs/bats-assert
git submodule add --force https://github.com/hiveminds/bash-package-installer dependencies/bash-package-installer
git submodule add --force https://github.com/hiveminds/bash-log dependencies/bash-log
git submodule update --remote --recursive
