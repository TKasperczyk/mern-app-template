#!/bin/bash

ROOT=$PWD

cd $ROOT/backend && npm start &
BACKEND_PID=$!

cd $ROOT/frontend && npm start &
FRONTEND_PID=$!

trap "trap - SIGTERM && kill $FRONTEND_PID && kill $BACKEND_PID" SIGINT SIGTERM EXIT
wait $FRONTEND_PID