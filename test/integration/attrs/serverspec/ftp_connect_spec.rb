# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Xabier de Zuazo
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
require 'type/ftp_server'
require 'type/ftps_server'

context 'FTP connection' do
  describe ftp_server('localhost') do
    it { should connect }
    it { should authenticate 'user1', 'user1' }
    it { should authenticate 'anonymous', nil }
    it { should_not authenticate 'baduser', 'baduser' }
  end

  describe ftps_server('localhost') do
    it { should connect }
    it { should authenticate 'user1', 'user1' }
  end
end
