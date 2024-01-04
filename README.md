# Docker Yocto
Using Docker or Podman for general Yocto builds

# Instructions

## Docker
```
docker build --build-arg USERNAME=<user_name> --build-arg UID="$(id -u)" -t yocto-img .
./docker.run -u <user_name> -s $(pwd)/workspace -i yocto-img /bin/bash

# Use <user_name> for the password below
sudo chown -R <user_name> workspace

source build.sh
```

Where `<user_name>` is any user name you want to have for inside the container. This does not need to be your host computer's username.

## Podman
```
podman build --build-arg USERNAME=<user_name> --build-arg UID="$(id -u)" -t yocto-img .
./podman.run -u <user_name> -s $(pwd)/workspace -i yocto-img /bin/bash
source build.sh
```

Where `<user_name>` is any user name you want to have for inside the container. This does not need to be your host computer's username.
