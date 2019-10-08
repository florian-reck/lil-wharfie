#!/bin/bash
storage_dir="/mnt/hdd"
oldpwd=$PWD
dpkg_arch=$(dpkg-architecture -qDEB_HOST_ARCH)

for directory in $(find $PWD -maxdepth 2 -type f -name "docker-parameter" -print0| xargs -0 dirname |sort);
do
    basedir=$(basename "${directory}")
    cd "$directory"
    if [ -f "docker-parameter" ]; then
        container_name="${basedir:3}"
        image_name="lilwharfie_${container_name}:${dpkg_arch}"
        docker rm -f $container_name
        docker create --name $container_name --hostname $container_name \
            -v "${storage_dir}":/storage:rw,z \
            $(cat docker-parameter) \
            $image_name
        docker start $container_name
        sleep 3s
    fi;    
done

cd "$oldpwd"
