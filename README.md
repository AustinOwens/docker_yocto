# Docker Yocto
Using Docker for general Yocto builds

# Instructions
1. `docker build --build-arg USERNAME=<user_name> -t yocto-img .`
2. `./docker.run -u <user_name> -s $(pwd)/workspace -i yocto-img`
3. `sudo chown -R <user_name> workspace` Where the password is your `<user_name>`
4. `source build.sh`
