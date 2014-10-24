# encoding: UTF-8
#
# Cookbook Name:: onddo_proftpd
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'onddo_proftpd'
maintainer 'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license 'Apache 2.0'
description 'Installs and Configures ProFTPD ftp server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.1.0' # WiP

depends 'ohai'
depends 'yum-epel'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'redhat'
supports 'ubuntu'

conflicts 'proftpd'

recipe 'onddo_proftpd::default', 'Installs and Configures ProFTPD.'
recipe 'onddo_proftpd::ohai_plugin',
       'Installs ProFTPD ohai plugin. Called by the ::default recipe.'

attribute 'proftpd/conf_files_user',
          display_name: 'ProFTPD configuration files user.',
          description: 'System user to own the ProFTPD configuration files.',
          type: 'string',
          required: 'optional',
          default: '"root"'

attribute 'proftpd/conf_files_group',
          display_name: 'ProFTPD configuration files group.',
          description: 'System group to own the ProFTPD configuration files.',
          type: 'string',
          required: 'optional',
          default: '"root"'

attribute 'proftpd/conf_files_mode',
          display_name: 'ProFTPD configuration files mode.',
          description: 'ProFTPD configuration files system file mode bits.',
          type: 'string',
          required: 'optional',
          default: '"00640"'

attribute 'proftpd/module_packages',
          display_name: 'ProFTPD module packages.',
          description:
            'ProFTPD system packages required to use some modules. This is '\
            'distribution specific and usually there is no need to change it.',
          type: 'hash',
          required: 'optional',
          calculated: true

attribute 'proftpd/conf',
          display_name: 'ProFTPD configuration.',
          description: 'ProFTPD configuration as key/value multi-level Hash.',
          type: 'hash',
          required: 'optional',
          calculated: true
