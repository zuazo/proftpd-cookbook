# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
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

require_relative 'ftp_server'
require 'double_bag_ftps'

module Serverspec
  # Serverspec resource types.
  module Type
    # Serverspec FTP resource type.
    class FtpsServer < FtpServer
      def to_s
        %(FTP "ftps://#{@host}")
      end

      def ftp_connect
        ftp.connect(@host)
        # Fix https://github.com/bnix/double-bag-ftps/issues/9
        ftp.send(:decorate_socket, ftp.instance_variable_get(:@sock))
      end

      def ftp
        @ftp ||= begin
          DoubleBagFTPS.new.tap do |ftps|
            ftps.ssl_context =
              DoubleBagFTPS.create_ssl_context(
                verify_mode: OpenSSL::SSL::VERIFY_NONE
              )
          end
        end
      end
    end

    def ftps_server(server)
      ::Serverspec::Type::FtpsServer.new(server)
    end
  end
end

include Serverspec::Type

RSpec::Matchers.define :connect do
  match(&:connects?)
end

RSpec::Matchers.define :authenticate do |user, pass|
  match do |subject|
    subject.authenticates?(user, pass)
  end
end
