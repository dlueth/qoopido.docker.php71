# recommended directory structure #
Like with my other containers I encourage you to follow a unified directory structure approach to keep things simple & maintainable, e.g.:

```
project root
  - docker-compose.yaml
  - config
    - php71
      - fpm
        - php.ini (if needed)
        - conf.d
          - ...
  - htdocs
  - data
    - php71
      - sessions
      - logs
```

# Example docker-compose.yaml #
```
php:
  image: qoopido/php71:latest
  ports:
   - "9000:9000"
  volumes:
   - ./htdocs:/app/htdocs:z
   - ./config/php71:/app/config:z
   - ./data/php71:/app/data:z
```

# Or start container manually #
```
docker run -d -P -t -i -p 9000:9000 \
	-v [local path to htdocs]:/app/htdocs:z \
    -v [local path to config]:/app/config:z \
    -v [local path to data]:/app/data:z \
	--name php qoopido/php71:latest
```

# Included modules #
```
composer
php7.1
php7.1-fpm
php7.1-dev
php7.1-cli
php7.1-common
php7.1-intl
php7.1-bcmath
php7.1-mbstring
php7.1-soap
php7.1-xml
php7.1-zip
php7.1-apcu
php7.1-json
php7.1-gd
php7.1-curl
php7.1-mcrypt
php7.1-mysql
php7.1-sqlite
php-memcached
```

# Configuration #
Any files under ```/app/config``` will be symlinked into the container's filesystem beginning at ```/etc/php/7.1```. This can be used to overwrite the container's default php fpm configuration with a custom, project specific configuration.

If you need a custom shell script to be run on start or stop (e.g. to set symlinks) you can do so by creating the file ```/app/config/up.sh``` or ```/app/config/down.sh```.