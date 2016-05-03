[![Build Status](https://travis-ci.org/loomsen/puppet-elkstack.svg?branch=master)](https://travis-ci.org/loomsen/puppet-elkstack)

# elkstack

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
    * [Notes](#notes)
3. [Setup - The basics of getting started with elkstack](#setup)
    * [What elkstack affects](#what-elkstack-affects)
    * [Setup requirements](#setup-requirements)
    * [Getting started with elkstack](#getting-started)
4. [Configuration - options and additional functionality](#configuration)
    * [Examples](#examples)
    * [More Options](#more-options)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Editors](#editors)
8. [Contributors](#contributors)

## Overview

The elkstack module installs, configures and manages elkstack on CentOS systems.

## Module Description
The elkstack module installs, configures and manages elkstack (elasticsearch, kibana, logstash)
For how to configure this, [please see below](#more-options)

### Notes
This module is best used with an ENC like hiera. It will make your config much easier to read and to maintain. Check the examples to see what I mean.

## Setup

### What elkstack affects

* This module will install the elkstack (elasticsearch, kibana, logstash) on your system
* This module will manage basic configs of each component on your system
* This module will manage the services on your system

### Setup Requirements

### Getting Started
You can simply include the class in your config, it should suffice. The defaults should be fine
in hiera:

```yaml
classes:
  - elkstack
```

## Configuration
Here are some more elaborate examples of what you can do with this module.

### Examples
This installs the elkstack, install the plugins for the stack, and downloads a PSQL JDBC connector to /usr/share/elasticsearch/lib. 
It adds a line to kibanas config reading: `server.host: localhost`

```yaml
classes:
  - elkstack

elkstack::plugins:
  elasticsearch:
    - 'license'
    - 'marvel-agent'
  logstash:
    - 'logstash-input-jdbc'
  kibana:
    - 'elasticsearch/marvel/latest'
    - 'elastic/sense'
  drivers:
    - 'https://jdbc.postgresql.org/download/postgresql-9.4.1208.jar'

elkstack::with_nginx: false

elkstack::kibana_config:
  - "server.host: localhost"

```


### More options
The defaults are pretty reasonable, I hope. However, you may override pretty much anything. Available parameters are discussed below. 

## Reference

### Classes

#### Public Classes
* elkstack: Main class, includes all other classes.

#### Private Classes

* elkstack::install: Handles the packages.
* elkstack::config: Handles configuration files.
* elkstack::params: default values.
* elkstack::plugins: Handles the plugins.

### Functions

### Parameters

The following parameters are available in the `::elkstack` class:


#### `$es_config`
Elasticsearch configuration. This goes into /etc/elasticsearch/elasticsearch.yml line by line.

Default is:  []

hiera example:

```yaml
elkstack::es_config:
  - 'cluster.name: my-cluster'
  - 'node.name: node1'
```


#### `$es_main_version`
Version for the CentOS repo. You probably want to leave this untouched.

Default is:  '2.x'


#### `$kibana_config`
Kibana configuration. This goes into /opt/kibana/config/kibana.yml line by line.

Default is:  

```puppet
  $kibana_config          = [
    'elasticsearch.url: "http://localhost:9200"',
    'server.host: localhost',
  ]
```

hiera example:

```yaml
elkstack::kibana_config:
  - 'elasticsearch.url: "http://example.com:9200"'
  - 'server.host: example.com'
```


#### `$kibana_main_version`
Kibana main version to install. Also the version used for creating the CentOS repo.

Default is:  '4.5'


#### `$logstash_config_filter`
Logstash filter configuration. This goes into /etc/logstash/conf.d/$filename-filter.conf line by line.

Default is:

```puppet
  $logstash_config_filter = {}
 ```

hiera example:

```yaml
elkstack::logstash_config_filter:
  10-mutate:
    - add_field => {"[@metadata][index_name]" => "%{literal('%')}{index_name}"}
    - add_field => {"[@metadata][index_type]" => "%{literal('%')}{index_type}"}
    - remove_field => ["index_type"]
    - remove_field => ["index_name"]
```


Resulting file:
`/etc/logstash/conf.d/10-mutate-filter.conf`

```
filter {
  mutate {
  add_field => {"[@metadata][index_name]" => "%{index_name}"}
  add_field => {"[@metadata][index_type]" => "%{index_type}"}
  remove_field => ["index_type"]
  remove_field => ["index_name"]
  }
}
```

#### `$logstash_config_input`
Logstash input configuration. This goes into /etc/logstash/conf.d/$filename-input.conf line by line.
The hash is of the form: (Please see examples below)

```puppet
$logstash_config_input = {
  01-filename => {
    input => { 
      "input_configuration=> line1"
      "another_input_config=> line2"
      }
    filter => {
      "filter {"
        "filter line here"
      "}"
    }
    output => {
      "outputname => indexname"
    }
  }
}
```


Default is:

```puppet
  $logstash_config_input  = {}
```

hiera example:

```yaml
elkstack::logstash_config_input:
  04-psql:
    input:
      - 'jdbc {'
      - 'jdbc_connection_string => "jdbc:postgresql://example.com:5432/mydb"'
      - 'jdbc_user => "myuser"'
      - 'jdbc_password => "mypassword"'
      - 'jdbc_paging_enabled => "true"'
      - 'jdbc_page_size => "50000"'
      - 'jdbc_validate_connection => true'
      - 'jdbc_driver_library => "/usr/share/elasticsearch/lib/postgresql-9.4.1208.jar"'
      - 'jdbc_driver_class => "org.postgresql.Driver"'
      - 'statement => "SELECT * FROM customer_list"'
      - '}'
    filter:
      - 'mutate {'
      - '}'
    output:
      - 'elasticsearch {'
      - 'index => "myindex"'
      - '}'

```

Resulting file:
`/etc/logstash/conf.d/04-psql-input.conf`

```
input {
  jdbc {
  jdbc_connection_string => "jdbc:postgresql://example.com:5432/mydb"
  jdbc_user => "myuser"
  jdbc_password => "mypassword"
  jdbc_paging_enabled => "true"
  jdbc_page_size => "50000"
  jdbc_validate_connection => true
  jdbc_driver_library => "/usr/share/elasticsearch/lib/postgresql-9.4.1208.jar"
  jdbc_driver_class => "org.postgresql.Driver"
  statement => "SELECT * FROM customer_list"
  }
}
filter {
  mutate {
  }
}
output {
  elasticsearch {
  index => "myindex"
  }
}
```


#### `$logstash_config_output`
Logstash output configuration. This goes into /etc/logstash/conf.d/$filename-output.conf line by line.

Default is:

```puppet
  $logstash_config_output = {
    '99-elasticsearch' => [
      'hosts           => ["localhost:9200"]',
      'sniffing        => true',
      'manage_template => false',
    ],
  }
```

Resulting file:
`/etc/logstash/conf.d/99-elasticsearch-output.conf`

hiera example:

```yaml
elkstack::logstash_config_output:
  99-elasticsearch:
    - 'hosts => ["localhost:9200"]'
    - 'sniffing => true'
    - 'manage_template => false'
```

```
output {
  elasticsearch {
  hosts           => ["localhost:9200"]
  sniffing        => true
  manage_template => false
  }
}
```


#### `$logstash_main_version`
logstash main version to install. Also the version used for creating the CentOS repo.

Default is:  '2.2'


#### `$package_name`
Default packages to install.

Default is:  [ 'elasticsearch', 'logstash', 'kibana', 'java' ]


#### `$plugins`
Optional plugins to install for each of the stack components. Also you can download additional files, like jdbc drivers here.

Default is:

```puppet
  $plugins                = {
    elasticsearch => ['license', 'marvel-agent'],
    logstash      => ['logstash-input-jdbc'],
    kibana        => ['elasticsearch/marvel/latest', 'elastic/sense'],
    drivers       => [],
  }
```

hiera example:

```yaml
elkstack::plugins:
  elasticsearch:
    - 'license'
    - 'marvel-agent'
  logstash:
    - 'logstash-input-jdbc'
  kibana:
    - 'elasticsearch/marvel/latest'
    - 'elastic/sense'
  drivers:
    - 'https://jdbc.postgresql.org/download/postgresql-9.4.1208.jar'
```


#### `$service_name`
Default services to manage.

Default is:  [ 'elasticsearch', 'kibana', 'logstash' ]


#### `$with_nginx`
If this is true, nginx will be installed, the service will be managed, and a simple kibana config will be placed in /etc/nginx/conf.d pointing to the systems FQDN.

Default is:  true


## Limitations
Currently, this module supports CentOS.

## Development
I have limited access to resources and time, so if you think this module is useful, like it, hate it, want to make it better or
want it off the face of the planet, feel free to get in touch with me.

## Editors
Norbert Varzariu (loomsen)

## Contributors
Hendrik Horeis <hendrik.horeis@gmail.com>
Additional contributors: please see the [list of contributors.](https://github.com/loomsen/puppet-elkstack/graphs/contributors)

