#!/bin/bash

ROOT=$PWD

cd $ROOT/backend && npm install
cd $ROOT/frontend && npm install

echo "Edit and save the sample configuration as ./backend/config/config.json before running!"