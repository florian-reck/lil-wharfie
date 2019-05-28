#!/bin/bash -e
oldpwd=$PWD
dpkg_arch=$(dpkg-architecture -qDEB_HOST_ARCH)

for directory in $(find $PWD -maxdepth 2 -type f -name Dockerfile -print0| xargs -0 dirname |sort);
do
    basedir=$(basename "${directory}")
    cd "$directory"

    if [ -f "Dockerfile" ]; then
        sed -r "s/(FROM lilwharfie_root:).*/\1${dpkg_arch}/g" Dockerfile > Dockerfile.tmp
        mv -v Dockerfile.tmp Dockerfile
    fi;

    if [ -f "make.sh" ]; then
        echo ./make.sh
    elif [ -f "Dockerfile" ]; then
        image_name="${basedir:3}"
        echo docker build -f Dockerfile -t "$image_name" .
    fi;    
done

cd "$oldpwd"
