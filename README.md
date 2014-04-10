Description
===========

[Chef](http://www.getchef.com/) Cookbook to install and configure the [ProFTPD](http://www.proftpd.org/) FTP server.

Requirements
============

## Platform:

* Amazon
* CentOS
* Debian
* Fedora
* Ubuntu

## Cookbooks:

* [ohai](http://community.opscode.com/cookbooks/ohai)
* [yum-epel](http://community.opscode.com/cookbooks/yum-epel)

Attributes
==========

<table>
  <tr>
    <td>Attribute</td>
    <td>Description</td>
    <td>Default</td>
  </tr>
  <tr>
    <td><code>node["proftpd"]["conf_files_user"]</code></td>
    <td>System user to own the ProFTPD configuration files.</td>
    <td><code>"root"</code></td>
  </tr>
  <tr>
    <td><code>node["proftpd"]["conf_files_group"]</code></td>
    <td>System group to own the ProFTPD configuration files.</td>
    <td><code>"root"</code></td>
  </tr>
  <tr>
    <td><code>node["proftpd"]["conf_files_mode"]</code></td>
    <td>ProFTPD configuration files system file mode bits.</td>
    <td><code>"00640"</code></td>
  </tr>
  <tr>
    <td><code>node["proftpd"]["module_packages"]</code></td>
    <td>ProFTPD system packages required to use some modules. This is distribution specific and usually there is no need to change it.'</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node["proftpd"]["conf"]</code></td>
    <td>ProFTPD configuration as key/value multi-level Hash.</td>
    <td><em>calculated</em></td>
  </tr>
</table>

Recipes
=======

## onddo_proftpd::default

Installs and Configures ProFTPD.

## onddo_proftpd::ohai_plugin

Installs ProFTPD ohai plugin. Called by the `::default` recipe

Testing
=======

## Requirements

### Gems

* `vagrant`
* `berkshelf` >= `2.0`
* `test-kitchen` >= `1.2`
* `kitchen-vagrant` >= `0.10`

### Cookbooks

Some extra cookbooks are required to run the tests:

* [ssl_certificate](http://community.opscode.com/cookbooks/ssl_certificate)

## Running the tests

```bash
$ kitchen test
$ kitchen verify
[...]
```

Contributing
============

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Copyright:**       | Copyright (c) 2014, Onddo Labs, SL. (www.onddo.com)
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
