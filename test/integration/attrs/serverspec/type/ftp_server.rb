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

require 'net/ftp'

module Serverspec
  # Serverspec resource types.
  module Type
    # Serverspec FTP resource type.
    class FtpServer < Base
      def initialize(host)
        @host = host
        super(@host)
      end

      def to_s
        %(FTP "ftp://#{@host}")
      end

      protected

      def ftp
        @ftp ||= ::Net::FTP.new(@host)
      end

      def ftp_connect
      end

      def ftp_close
        return if @ftp.nil?
        @ftp.close
      rescue ::SocketError, ::Errno::ETIMEDOUT, ::Net::FTPPermError
        nil
      ensure
        @ftp = nil
      end

      public

      def connects?
        ftp
        ftp_connect
        ftp_close
        true
      rescue ::SocketError, ::Errno::ETIMEDOUT, ::Net::FTPPermError
        false
      end

      def authenticates?(user, pass)
        ftp_connect
        ftp.login(user, pass)
        ftp.list
        ftp_close
        true
      rescue ::SocketError, ::Errno::ETIMEDOUT, ::Net::FTPPermError
        false
      end
    end

    def ftp_server(server)
      ::Serverspec::Type::FtpServer.new(server)
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
