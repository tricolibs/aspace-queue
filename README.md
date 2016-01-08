Super basic way to show how to use Redis with ArchivesSpace
=====================================

[Redis](http://redis.io/) is an open source (BSD licensed), in-memory data
structure store, used as database, cache and message broker. 

[Resque](https://github.com/resque/resque) is a Redis-backed Ruby library for
creating background jobs, placing them on multiple queues, and processing them
later. 

This plugin show how to send messages using a hook in the indexer. It's really
basic.

**To use with ArchivesSpace you must:**

- Install Redis 
  - [OS X](http://jasdeep.ca/2012/05/installing-redis-on-mac-os-x/)
  - [Linux](http://redis.io/topics/quickstart)
  - Windows?

- Update your config.rb
```
## You may have other plugins
AppConfig[:plugins] = ['local', 'aspace_queue']
```

- Initalize the plugin ( download the gems needed )
In Linux, from your ASPACE directory
```
$  ./scripts/initialize-plugin.sh aspace-queue
```

- Start the Resque monitoring web app ( optional )
```
$ resque-web
or 
$ bundle exec resque-web
```
And open your browser to localhost:5678 to see the redis application


- Start, or restart ArchivesSpace to pick up the configuration.


Have a look at the application. Whenever a record is run through the indexer,
it will put it into a queue ( called 'record_created'). If you look at this
queue, you'll see each job will have the ASPACE JSON waiting there for some
other process to pick it up and act on it.

Here's what the Resque app looked like:

![Resque Index
Page](https://raw.githubusercontent.com/archivesspace/aspace-queue/master/resque-index.png)

![Resque Queue
Page](https://raw.githubusercontent.com/archivesspace/aspace-queue/master/resque-queue.png)

Questions?

---
