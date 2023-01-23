# Docker Yocto
Using Docker for general Yocto builds

# Instructions
1. `docker build --build-arg USERNAME=<user_name> --build-arg UID="$(id -u)" -t yocto-img .`
2. `./docker.run -u <user_name> -s $(pwd)/workspace -i yocto-img` /bin/bash
4. `source build.sh`
