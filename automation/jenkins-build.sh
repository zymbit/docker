#!/bin/bash

VERSION=$(<VERSION)

head -n 26 Dockerfile > .DockerfileCross.swp
cat Dockerfile.cross >> .DockerfileCross.swp
tail -n 2 Dockerfile >> .DockerfileCross.swp
docker build -t "docker-builder:$VERSION" -f .DockerfileCross.swp .
rm .DockerfileCross.swp

docker run --rm --privileged -v "`pwd`:/go/src/github.com/docker/docker" "docker-builder:$VERSION" hack/make.sh binary cross

## ARM Build
mkdir -p docker-arm-$VERSION
rm -f docker-arm-$VERSION.tar
rm -f docker-arm*.tar.xz

cp bundles/$VERSION/cross/linux/arm/docker-$VERSION docker-arm-$VERSION/docker
tar -cJf docker-arm-$VERSION.tar.xz docker-arm-$VERSION && rm -rf docker-arm-$VERSION

## i386 Build
mkdir -p docker-386-$VERSION
rm -f docker-386-$VERSION.tar
rm -f docker-386*.tar.xz

cp bundles/$VERSION/cross/linux/386/docker-$VERSION docker-386-$VERSION/docker
tar -cJf docker-386-$VERSION.tar.xz docker-386-$VERSION && rm -rf docker-386-$VERSION
