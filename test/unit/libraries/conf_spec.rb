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

require_relative '../spec_helper'
require 'conf'

describe ProFTPD::Conf do
  context '.attribute_name' do
    {
      'BindDn' => 'BindDN',
      'MultilineRfc2228' => 'MultilineRFC2228',
      'UseIpv6' => 'UseIPv6',
      'VrootEngine' => 'VRootEngine',
      'TlsCaCertificateFile' => 'TLSCACertificateFile',
      'TlsVerifyClient' => 'TLSVerifyClient'
    }.each do |orig, new|
      it "returns #{new.inspect} from #{orig.inspect}" do
        expect(described_class.attribute_name(orig, '')).to eq(new)
      end
    end

    it 'returns VRootEngine from Engine with VRoot prefix' do
      expect(described_class.attribute_name('Engine', 'VRoot'))
        .to eq('VRootEngine')
    end
  end # context .attribute_name
end
