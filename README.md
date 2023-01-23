# Docker Yocto
Using Docker for general Yocto builds

# Instructions
```
docker build --build-arg USERNAME=<user_name> --build-arg UID="$(id -u)" -t yocto-img .
./docker.run -u <user_name> -s $(pwd)/workspace -i yocto-img /bin/bash
source build.sh
```

Where `<user_name>` is any user name you want to have for inside the container. This does not need to be your host computer's username.
