#!/bin/bash

printf "Deploying...\n"

BIN_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $BIN_DIR/.. && git push heroku master

printf "Deploy done!\n"