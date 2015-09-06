# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
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

require 'spec_helper'

proftpd_package =
  if %w(debian ubuntu).include?(os[:family].downcase)
    'proftpd-basic'
  else
    'proftpd'
  end

describe package(proftpd_package) do
  it { should be_installed }
end

describe process('proftpd') do
  it { should be_running }
end

describe port(21) do
  it { should be_listening }
end

describe file('/etc/proftpd') do
  it { should be_directory }
end

describe file('/etc/proftpd/conf.d') do
  it { should be_directory }
end

describe file('/etc/proftpd/proftpd.conf') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/proftpd.conf') do
  it { should be_linked_to '/etc/proftpd/proftpd.conf' }
end
