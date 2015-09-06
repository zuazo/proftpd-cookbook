ProFTPD Cookbook
================
[![Cookbook Version](https://img.shields.io/cookbook/v/onddo_proftpd.svg?style=flat)](https://supermarket.chef.io/cookbooks/onddo_proftpd)
[![Dependency Status](http://img.shields.io/gemnasium/zuazo/proftpd-cookbook.svg?style=flat)](https://gemnasium.com/zuazo/proftpd-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/zuazo/proftpd-cookbook.svg?style=flat)](https://codeclimate.com/github/zuazo/proftpd-cookbook)
[![Build Status](http://img.shields.io/travis/zuazo/proftpd-cookbook.svg?style=flat)](https://travis-ci.org/zuazo/proftpd-cookbook)

[Chef](http://www.chef.io/) Cookbook to install and configure the [ProFTPD](http://www.proftpd.org/) FTP server.

Requirements
============

## Supported Platforms

This cookbook has been tested on the following platforms:

* Amazon
* CentOS
* Debian
* Fedora
* RedHat
* Ubuntu

Please, [let us know](https://github.com/zuazo/proftpd-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Cookbooks

* [ohai](http://supermarket.chef.io/cookbooks/ohai)
* [yum-epel](http://supermarket.chef.io/cookbooks/yum-epel)

## Required Applications

* Ruby `>= 1.9.3`

Attributes
==========

| Attribute                             | Default      | Description                       |
|:--------------------------------------|:-------------|:----------------------------------|
| `node['proftpd']['conf_files_user']`  | `'root'`     | System user to own the ProFTPD configuration files.
| `node['proftpd']['conf_files_group']` | `'root'`     | System group to own the ProFTPD configuration files.
| `node['proftpd']['conf_files_mode']`  | `'00640'`    | ProFTPD configuration files system file mode bits.
| `node['proftpd']['module_packages']`  | *calculated* | ProFTPD system packages required to use some modules. This is distribution specific and usually there is no need to change it.
| `node['proftpd']['conf']`             | *calculated* | ProFTPD configuration as key/value multi-level Hash.

Recipes
=======

## onddo_proftpd::default

Installs and Configures ProFTPD.

## onddo_proftpd::ohai_plugin

Installs ProFTPD ohai plugin. Called by the `::default` recipe.

Usage
=====

## Including in a Cookbook Recipe

You can simply include it in a recipe:

```ruby
# from a recipe
include_recipe 'onddo_proftpd'
```

Don't forget to include the `onddo_proftpd` cookbook as a dependency in the metadata.

```ruby
# metadata.rb
[...]

depends 'onddo_proftpd'
```

## Including in the Run List

Another alternative is to include the default recipe in your Run List.

```json
{
  "name": "ftp.example.com",
  [...]
  "run_list": [
    [...]
    "recipe[onddo_proftpd]"
  ]
}
```

## Changing the Configuration

Configuration directives will be created inside the `proftpd.conf` file. Other configuration files will be ignored unless included. By default, only the `conf.d` directory will be included:

```ruby
node.default['proftpd']['conf']['include'] = %w{/etc/proftpd/conf.d}
```

All the configuration for the `proftpd.conf` file is read from the `node['proftpd']['conf']` attribute.

Under this namespace, you can set configuration directives using both the *CamelCase* and *the_underscore* syntax.

For example, using the underscore syntax:

```ruby
node.default['proftpd']['conf']['use_ipv6'] = false
node.default['proftpd']['conf']['ident_lookups'] = false
node.default['proftpd']['conf']['server_name'] = 'My FTP server'

include_recipe 'onddo_proftpd'
```

Using the camelcase syntax:

```ruby
node.default['proftpd']['conf']['UseIPv6'] = false
node.default['proftpd']['conf']['IdentLookups'] = false
node.default['proftpd']['conf']['ServerName'] = 'My FTP server'

include_recipe 'onddo_proftpd'
```

The cookbook will try to do the correct conversion from underscore to camelcase including some edge cases, like for example `UseIPv6` (you don't need to use `use_i_pv6`, `use_ipv6` is OK also).

In any case, use the syntax you prefer.

## Block Directives

Some of the directives set in the attributes will be treated in a special way:

* `Global` or `global`: will create a `<Global>` block, must contain an *Array* of directives.
* `Directory` or `directory`: will create a `<Directory>` block, must contain a *Hash* of directives.
* `VirtualHost` or `virtual_host`: will create a `<VirtualHost>` block, must contain a *Hash* of directives.
* `Anonymous` or `anonymous`: will create a `<Anonymous>` block, must contain a *Hash* of directives.
* `Limit` or `limit`: will create a `<Limit>` block, must contain a *Hash* of directives.
* `IfAuthenticated` or `if_authenticated`: will create a `<IfAuthenticated>` block, must contain an *Array* of directives.
* `IfModule` or `if_module`: will create a `<IfModule>` block, must contain a *Hash* of directives.
* `IfClass` or `if_class`: will create a `<IfClass>` block, must contain a *Hash* of directives.
* `IfGroup` or `if_group`: will create a `<IfGroup>` block, must contain a *Hash* of directives.
* `IfUser` or `if_user`: will create a `<IfUser>` block, must contain a *Hash* of directives.

See the examples below to learn how to use them.

## Valueless Directives

If the directive has no value, like `AllowAll` or `DenyAll`, you set it to `nil` to enable it. For example:

```ruby
node.default['proftpd']['conf']['anonymous']['~ftp']['directory']['*']['limit']['write']['deny_all'] = nil
node.default['proftpd']['conf']['anonymous']['~ftp']['directory']['incoming']['limit']['read write']['deny_all'] = nil
node.default['proftpd']['conf']['anonymous']['~ftp']['directory']['incoming']['limit']['stor']['allow_all'] = nil
```

## Configuring a Module

The best way to set a module configuration is to use the `<IfModule>` configuration directive. For example:

```ruby
# mod_ctrls_admin.c module
node.default['proftpd']['conf']['if_module']['ctrls_admin']['admin_controls_engine'] = false
```

You can use the full module name if you prefer (`mod_*.c`):

```ruby
node.default['proftpd']['conf']['if_module']['mod_ctrls_admin.c']['admin_controls_engine'] = false
```

You can also use the special `['prefix']` key to save putting a prefix in all the configuration directives:

```ruby
# Create a <IfModule mod_ctls.so> directive block
node.default['proftpd']['conf']['if_module']['ctrls']['prefix'] = 'Controls'
node.default['proftpd']['conf']['if_module']['ctrls']['engine'] = false # ControlsEngine
node.default['proftpd']['conf']['if_module']['ctrls']['max_clients'] = 2 # ControlsMaxClients
node.default['proftpd']['conf']['if_module']['ctrls']['log'] = '/var/log/proftpd/controls.log' # ControlsLog
node.default['proftpd']['conf']['if_module']['ctrls']['interval'] = 5 # ControlsInterval
node.default['proftpd']['conf']['if_module']['ctrls']['socket'] = '/var/run/proftpd/proftpd.sock' # ControlsSocket
```

This prefix will only be applied under the current block (`<IfModule mod_ctls.so>` in this example), **excluding** deeper blocks under `['ctrls']`, like for example `['ctrls']['directory']['*'][...]`.

## Enabling SSL/TLS

In the following example, we are using the [ssl_certificate](http://supermarket.chef.io/cookbooks/ssl_certificate) cookbook to create the certificate:

```ruby
# TLS configuration
cert = ssl_certificate 'proftpd' do
  common_name node['fqdn'] || 'ftp.example.com'
end
node.default['proftpd']['conf']['if_module']['tls']['prefix'] = 'TLS'
node.default['proftpd']['conf']['if_module']['tls']['engine'] = true
node.default['proftpd']['conf']['if_module']['tls']['log'] = '/var/log/proftpd/tls.log'
# Support both SSLv3 and TLSv1
node.default['proftpd']['conf']['if_module']['tls']['protocol'] = 'SSLv3 TLSv1'
# Are clients required to use FTP over TLS when talking to this server?
node.default['proftpd']['conf']['if_module']['tls']['required'] = false
node.default['proftpd']['conf']['if_module']['tls']['rsa_certificate_file'] = cert.cert_path
node.default['proftpd']['conf']['if_module']['tls']['rsa_certificate_key_file'] = cert.key_path
# Authenticate clients that want to use FTP over TLS?
node.default['proftpd']['conf']['if_module']['tls']['verify_client'] = false
# Avoid CA cert with relaxed session use for some clients (e.g. FireFtp)
node.default['proftpd']['conf']['if_module']['tls']['options'] = 'NoCertRequest EnableDiags NoSessionReuseRequired'
# Allow SSL/TLS renegotiations when the client requests them, but
# do not force the renegotations.  Some clients do not support
# SSL/TLS renegotiations; when mod_tls forces a renegotiation, these
# clients will close the data connection, or there will be a timeout
# on an idle data connection.
node.default['proftpd']['conf']['if_module']['tls']['renegotiate'] = 'none'

include_recipe 'onddo_proftpd'
```

## Creating a VirtualHost

```ruby
node.default['proftpd']['conf']['virtual_host']['ftp.server.com'] = {
  'server_admin' => 'ftpmaster@server.com',
  'server_name' => 'Big FTP Archive',
  'transfer_log' => '/var/log/proftpd/xfer-ftp.server.com.log',
  'max_login_attempts' => 3,
  'require_valid_shell' => false,
  'default_root' => '/tmp',
  'allow_overwrite' => true,
}

include_recipe 'onddo_proftpd'
```

## Creating an Anonymous FTP

```ruby
user 'ftp' do
  system true
  shell '/bin/false'
  supports :manage_home => true
end

node.default['proftpd']['conf']['require_valid_shell'] = false

node.default['proftpd']['conf']['anonymous']['~ftp'] = {
  'user' => 'ftp',
  'group' => 'nogroup',
  'user_alias' => 'anonymous ftp',
  'dir_fake_user' => 'on ftp',
  'dir_fake_group' => 'on ftp',
  'require_valid_shell' => false,
  'max_clients' => 10,
  'display_login' => 'welcome.msg',
  'display_chdir' => '.message',
  'directory' => {
    '*' => {
      'limit' => {
        'write' => {
          'deny_all' => nil,
        },
      },
    },
    'incoming' => {
      'umask' => '022 022',
      'limit' => {
        'read write' => {
          'deny_all' => nil,
        },
        'stor' => {
          'allow_all' => nil,
        },
      },
    },
  },
}
```

Testing
=======

See [TESTING.md](https://github.com/zuazo/proftpd-cookbook/blob/master/TESTING.md).

Contributing
============

Please do not hesitate to [open an issue](https://github.com/zuazo/proftpd-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](https://github.com/zuazo/proftpd-cookbook/blob/master/CONTRIBUTING.md).

TODO
====

See [TODO.md](https://github.com/zuazo/proftpd-cookbook/blob/master/TODO.md).


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@zuazo.org>)
| **Copyright:**       | Copyright (c) 2015, Xabier de Zuazo
| **Copyright:**       | Copyright (c) 2014, Onddo Labs, SL.
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
