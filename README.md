# puppet-etcd

[![Build Status](https://github.com/voxpupuli/puppet-etcd/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-etcd/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-etcd/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-etcd/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/etcd.svg)](https://forge.puppetlabs.com/puppet/etcd)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/etcd.svg)](https://forge.puppetlabs.com/puppet/etcd)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/etcd.svg)](https://forge.puppetlabs.com/puppet/etcd)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/etcd.svg)](https://forge.puppetlabs.com/puppet/etcd)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-etcd)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-etcd.svg)](LICENSE)
[![Donated by Tailored Automation](https://img.shields.io/badge/donated%20by-Tailored%20Automation-fb7047.svg)](#transfer-notice)

#### Table of Contents

1. [Module Description](#module-description)
1. [Setup - The basics of getting started with Etcd](#setup)
    * [What etcd affects](#what-etcd-affects)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
    * [Basic Etcd](#basic-etcd)
    * [Clustered Etcd](#clustered-etcd)
    * [Etcd Upgrades](#etcd-upgrades)
    * [SSL configuration](#ssl-configuration)
1. [Reference](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Transfer Notice](#transfer-notice)

## Module Description

Installs and manages [Etcd](https://etcd.io/)

### Documented with Puppet Strings

[Puppet Strings documentation](http://tailored-automation.github.io/puppet-module-etcd/)

## Setup - The basics of getting started with Etcd

## What etcd affects

This module will download the compiled binaries for etcd and extra the archive and install the necessary binaries, configuration files and services.

## Setup requirements

All module dependencies are listed in this module's `metadata.json`.

## Usage - Configuration options and additional functionality

### Basic Etcd

To install and run a single instance of etcd it's sufficient to just include the `etcd` class:

```puppet
include etcd
```

All configuration for etcd.yaml is done via the `config` parameter, example:

```puppet
class { 'etcd':
  config => {
    'data-dir' => '/var/lib/etcd',
    'wal-dir'  => '/var/lib/etcd/wal',
  },
}
```

### Clustered Etcd

The following is an example of a clustered etcd setup.
Adjust `name`, `initial-advertise-peer-urls` and `advertise-client-urls` for each host in the cluster.

```puppet
class { 'etcd':
  config => {
    'data-dir'                    => '/var/lib/etcd',
    'name'                        => 'infra1',
    'initial-advertise-peer-urls' => 'http://10.0.1.10:2380',
    'listen-peer-urls'            => 'http://0.0.0.0:2380',
    'listen-client-urls'          => 'http://0.0.0.0:2379',
    'advertise-client-urls'       => 'http://10.0.1.10:2379',
    'initial-cluster-token'       => 'etcd-cluster-1',
    'initial-cluster'             => 'infra0=http://10.0.1.10:2380,infra1=http://10.0.1.11:2380,infra2=http://10.0.1.12:2380',
    'initial-cluster-state'       => 'new',
  },
}
```

### Etcd Upgrades

Upgrades using this module are performed by increasing the value provided to `version`.

If the previous version was `3.4.7` then the following would upgrade etcd to `4.0.0`:

```puppet
class { 'etcd':
  version => '4.0.0',
}
```

Puppet will download the new etcd, update the symlinks for etcd binary and restart the etcd service.

### SSL configuration

Below is an example of setting up SSL authentication as well as SSL peering between hosts in etcd cluster:

```puppet
class { 'etcd':
  config => {
    'name'                        => $facts['networking']['fqdn'],
    'initial-advertise-peer-urls' => "https://${facts['networking']['fqdn']}:2380",
    'listen-peer-urls'            => "https://${facts['networking']['ip']}:2380",
    'listen-client-urls'          => "https://${facts['networking']['ip']}:2379",
    'advertise-client-urls'       => "https://${facts['networking']['fqdn']}:2379",
    'initial-cluster-token'       => 'etcd-cluster-1',
    'initial-cluster'             => 'https://etcd1.example.com:2380,https://etcd2.example.com:2380,https://etcd3.example.com:2380',
    'initial-cluster-state'       => 'new',
    'client-transport-security'   => {
      'trusted-ca-file'  => '/etc/pki/tls/my-ca.pem',
      'cert-file'        => '/etc/pki/tls/etcd.crt',
      'key-file'         => '/etc/pki/tls/etcd.key',
      'client-cert-auth' => true,
    },
    'peer-transport-security'     => {
      'trusted-ca-file'  => '/etc/pki/tls/my-ca.pem',
      'cert-file'        => '/etc/pki/tls/etcd.crt',
      'key-file'         => '/etc/pki/tls/etcd.key',
      'client-cert-auth' => true,
    },
  },
}
```

### Limitations

This module is only supported on Linux based systems.
Check the metadata.json for all tested operating systems.

## Transfer Notice

This plugin was originally authored by [Tailored Automation](https://tailoredautomation.io/).
The maintainer preferred that Vox Pupuli take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.
