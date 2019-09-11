# simple-squid-cache

Simple to set up, high performing datasaving proxy for home users, build using KISS principles.

## Description and motivation

So, in these days of multi Mbit internet connections and fast cpu's, why would you want a caching proxy? More and more, people are changing to mobile connections or similarly connections with fluctuating bandwidth. Often, such connections are also datalimited in some fashion, so it makes sense to cache data and lessen the Mbit requirement on your internet connection.

Moreover, today many sites we visit are the same, and those sites use a great number of static content, which is still retrieved via "old fashioned" HTTP connections.

Tuning Squid to allow Massive cache sizes, both on disk and in memory can allow for the reuse of many of such resources, improving the performance of your network connection.

## Usage

The image will run with no additional configuration:

    docker run -d -p 3128:3128 stixes/simple-squid-cache

and will provide a default configuration with 1Gb in-memory cache and 8gb on-disk cache, making it fitt well on the higher end home NAS or your some server setup.
The cache can be persist outside the container using volumes:

    docker volume create squid-cache
    docker run -d -v squid-cache:/var/cache/squid -p 3128:3128 stixes/simple-squid-cache

or using host mapping:

    docker run -d -v /opt/dockerstorage/squid-cache:/var/cache/squid -p 3128:3128 stixes/simple-squid-cache
    
The cache size is controlled using two environment variables:

* SQUID\_DISK\_SIZE\_MB - The size in MB for the on disk size. Default is 8192 (8gb). Bigger is good here.
* SQUID\_MEM\_SIZE\_MB - The amount of memory used to cache most recent request. Default is 1024 (1Gb). This should be adjusted to fit your server.

Thats it. It's simple.

## Sample docker-compose

A nice way to run this, is as a docker-compose service (and this service wil also run easily in a docker swarm stack). Here is a sample, which doubles the space allotted for disk and memory:

    version: "2.4"
    volumes:
      cache:
    services:
      squid:
        image: stixes/simple-squid-cache
        ports:
          - 3128:3128
        restart: always
        environment:
          SQUID_DISK_SIZE_MB: 20480
          SQUID_MEM_SIZE_MB: 2048
        volumes:
          - cache:/var/cache/squid


