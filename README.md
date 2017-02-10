# Prophusion

**pro·fu·sion**  
*/prəˈfyo͞oZHən/*  
noun

an abundance or large quantity of something.

## What's prophusion?
Prophusion makes it fast and easy to test your php code against **any** release of php since 5.3.9. There are over 140 releases you can choose from.

It consists of
 * [phpenv](https://github.com/CHH/phpenv)
 * A [docker](https://www.docker.com/) image (the one built by this respository) to provide a known environment;
 * Some infrastructure to host php binaries built for the docker image;
 * A bash script that downloads php builds into your container as needed.
 
## Basic Usage
 1. [Install docker](https://docs.docker.com/engine/installation/)
 2. In your terminal, run the command `docker run -it prophusion/prophusion-base`.  
    The prophusion base docker image will download and start.
 3. With the container started, run this command within it:  
    ```prophusion global 5.3.9```  
    PHP version 5.3.9 will be downloaded, verified, decompressed, unpacked, and installed inside this docker container. On a fast connection, the entire process completes in about 6 seconds.
    
    You can verify the php version by running `php -v`.
 4. You can test with another version by simply running e.g. `prophusion global 7.0.0`.

## What's included?
The php builds that prophusion downloads contain the php command-line interpreter 
and php-fpm. If you need a full webserver, try [prophusion/prophusion-apache.](https://hub.docker.com/r/prophusion/prophusion-apache/)

The docker image contains the necessary libraries for a reasonable assortment of extensions
like openssl, pdo_mysql, and gd. Here's the complete list of enabled extensions in version 7.0.0:

```
# php -r 'echo implode(", ", get_loaded_extensions()) . "\n";'
Core, date, libxml, openssl, pcre, sqlite3, zlib, bcmath, ctype, curl, dom, hash, fileinfo, 
filter, ftp, gd, SPL, iconv, json, mbstring, mcrypt, session, pcntl, PDO, standard,
pdo_sqlite, Phar, posix, readline, Reflection, mysqlnd, shmop, SimpleXML, soap, sockets,
pdo_mysql, exif, sysvsem, sysvshm, tidy, tokenizer, xml, xmlreader, xmlrpc, xmlwriter, xsl,
zip, mysqli, Zend OPcache, xdebug
```
 
## Additional Usage
### PHP_VERSION environment variable
 If you don't want to run `prophusion global [version]` in the shell every time a container is run, you can set PHP_VERSION as part of `docker run`:   
 ```docker run -it -e "PHP_VERSION=7.0.10" prophusion/prophusion-base```  
 This will cause the requested version to be installed as part of the container's startup.
### Running a custom script on startup
 The image launches bash by default, but you can override it to run some other process in the container.  
 For example:  
 ```docker run -e "PHP_VERSION=7.0.0" -v /path/to/my-killer-app:/app prophusion/prophusion-base /app/run-tests.sh```
 The container runs `/app/run-tests.sh`, which is found on the docker host at `/path/to/my-killer-app/run-tests.sh`.
### Changing the PHP version from the docker host
 If you aren't running the container with an interactive shell and for some reason want to provoke a PHP version change within it, you can:  
 ```docker exec [container-name] prophusion global [new.php.version]```  
 where `container-name` is the container name or id as listed by `docker ps`, and `new.php.version` is the next php version you want the container to run.
 
 If you do this, it may be difficult to synchronize when the version change occurs with processes running within the container.
### Sending xdebug connections to the docker host
 There is built-in assistance for configuring xdebug within the container to connect out to a debugger you have listening on the docker host. Simply add `-e XDEBUG2HOST=1` to your `docker run` at container startup time, or run the command `xdebug2host` after the container has started. This sets a few environment variables to the values xdebug is looking for.
 
 Additionally, the value of `XDEBUG2HOST` is copied into `PHP_IDE_CONFIG`. This can be used to cue your chosen debugger to use certain predefined container path → host path mappings to your source files, or other custom preferences for this project/container.
 
 If you use PHPStorm to debug, you can set `XDEBUG2HOST="serverName=xyz"` and then [configure path mappings in PHPStorm](https://www.jetbrains.com/help/phpstorm/2016.3/servers.html) for a server 'xyz'.
  

## Bugs, Feature Requests, & Contributing
 * If you've found a bug or want to request a feature, please
   [create an issue on github](https://github.com/prophusion/prophusion-base/issues) to report it.
 * How you can help:
   - Pull requests to [prophusion's repositories](https://github.com/prophusion) on github are welcome!
   - Host a mirror of the PHP builds. Contact `mike@mbaynton.com` if you'd like to help in this way.
