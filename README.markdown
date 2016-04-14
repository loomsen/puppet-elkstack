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

The elkstack module installs, configures and manages elkstack on 

## Module Description
The elkstack module installs, configures and manages elkstack 
For how to configure this, [please see below](#more-options)

### Notes

## Setup

### What elkstack affects

* This module will install the elkstack package on your system
* This module will manage the elkstack config on your system
* This module will manage the service on your system

### Setup Requirements

### Getting Started

## Configuration
Here are some more elaborate examples of what you can do with this module.

### Examples

### More options

#### Specials

## Reference

### Classes

#### Public Classes
* elkstack: Main class, includes all other classes.

#### Private Classes

* elkstack::install: Handles the packages.
* elkstack::config: Handles configuration and cron files.
* elkstack::params: default values.

### Functions

### Parameters

The following parameters are available in the `::elkstack` class:


#### `$package_name`

Default is:  [ 'elasticsearch', 'logstash', 'kibana', 'nginx', 'java' ]


#### `$service_name`

Default is:  [ 'elasticsearch', 'kibana', 'nginx' ]


#### `$es_config`

Default is:  [ ]


#### `$kibana_config`

Default is:  [ ]


#### `$logstash_config_output`

Default is:  {}


#### `$logstash_config_input`

Default is:

```puppet
  $logstash_config_input = {
    input  => {},
    output => {},
  }
```


## Limitations
Currently, this module support CentOS, Fedora, Ubuntu and Debian.

## Development
I have limited access to resources and time, so if you think this module is useful, like it, hate it, want to make it better or
want it off the face of the planet, feel free to get in touch with me.

## Editors
Norbert Varzariu (loomsen)

## Contributors
Please see the [list of contributors.](https://github.com/loomsen/puppet-elkstack/graphs/contributors)

