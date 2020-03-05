#!/bin/bash
VERSION=c281
docker build . -t markz0r/eramba-app:$VERSION
docker push markz0r/eramba-app:$VERSION
