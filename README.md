# Prophusion

**pro·fu·sion**  
*/prəˈfyo͞oZHən/*  
noun

an abundance or large quantity of something.

## What's prophusion?
Prophusion is intended to be an easy and efficient way to test php code against **any** release of php,
at least since 5.3.9.

It consists of
 * [phpenv](https://github.com/CHH/phpenv)
 * A [docker](https://www.docker.com/) image (the one built by this respository) to provide a known 
   environment;
 * Some infrastructure to host php binaries built for the docker image;
 * A bash script that downloads php builds into your container as needed.
 
## Basic Usage
 1. [Install docker](https://docs.docker.com/engine/installation/)
 2. In your terminal, run the command `docker run -it prophusion/prophusion-base`.  
    The prophusion base docker image will download and start.
 3. With the container started, run this command within it:  
    `prophusion global 5.3.9`  
    PHP version 5.3.9 will be downloaded, verified, decompressed, unpacked, and installed inside this
    docker container. On a fast connection, the entire process completes in about 6 seconds.
    
    You can verify the php version by running `php -v`.