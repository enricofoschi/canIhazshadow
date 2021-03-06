#!/bin/bash

printf "Updating repos...\n"

BIN_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $BIN_DIR/.. && git pull origin master
cd $BIN_DIR/../../crater.js && git pull origin master

printf "Repos updated!\n"