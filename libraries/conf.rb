# encoding: UTF-8
#
# Cookbook Name:: onddo_proftpd
# Library:: conf
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

module ProFTPD
  module Conf
    @@compiled_in_modules = []

    def self.compiled_in_modules(mods)
      @@compiled_in_modules = mods if mods.kind_of?(Array)
    end

    def self.module_compiled_in?(mod)
      mod =
        if mod =~ /^mod_(.+).c$/
          $1
        else
          mod
      end.downcase
      @@compiled_in_modules.include?(mod.to_s.downcase)
    end

    # not used
    def self.camel2underscore(str)
      str.gsub(/([^A-Z])([A-Z])/,'\1_\2').downcase
    end

    def self.underscore2camel(str)
      str.split('_').map { |e| e.capitalize }.join
    end

    def self.string_quotes_fix(name, value)
      %w{
        AccessDenyMsg
        AccessGrantMsg
        LDAPServer
        ServerAdmin
        ServerName
        StoreUniquePrefix
      }.include?(name) && value !~ /"/ ? "\"#{value}\"" : value
    end

    def self.module_name_fix(name)
      "mod_#{name}.c" if name !~ /^mod_.*\.c$/
    end

    # Fix some camelcase conversions
    def self.attribute_name(name, prefix)
      prefix.to_s + case name
      when /^(.*)Acls$/;        "#{$1}ACLs"
      when /^CdP(.*)$/;         "CDP#{$1}"
      when /^(.*)Cpu$/;         "#{$1}CPU"
      when /^(.*)Dn$/;          "#{$1}DN"
      when /^(.*)Dns$/;         "#{$1}DNS"
      when /^(.*)Gid(.*)$/;     "#{$1}GID#{$2}"
      when /^(.*)Gmt$/;         "#{$1}GMT"
      when /^(.*)Ipv6$/;        "#{$1}IPv6"
      when /^Ldap(.*)$/;        "LDAP#{$1}"
      when /^(.*)Pam$/;         "#{$1}PAM"
      when /^(.*)PamConfig$/;   "#{$1}PAMConfig"
      when /^(.*)Rfc([0-9]+)$/; "#{$1}RFC#{$2}"
      when /^Sql(.*)$/;         "SQL#{$1}"
      when /^Sql(.*)$/;         "SQL#{$1}"
      when /^Tcp(.*)$/;         "TCP#{$1}"
      when /^(.*)Tls$/;         "#{$1}TLS"
      when /^TlsCa(.*)$/;       "TLSCA#{$1}"
      when /^TlsDh(.*)$/;       "TLSDH#{$1}"
      when /^TlsDsa(.*)$/;      "TLSDSA#{$1}"
      when /^TlsRsa(.*)$/;      "TLSRSA#{$1}"
      when /^Tls(.*)$/;         "TLS#{$1}"
      when /^(.*)Uid(.*)$/;     "#{$1}UID#{$2}"
      when /^(.*)Utf8$/;        "#{$1}UTF8"
      when /^Vroot(.*)$/;       "VRoot#{$1}"
      else
        name
      end
    end

    def self.attribute_value(v)
      case v
      when Array
        v.map { |x| attribute_value(x) }.join(' ')
      when TrueClass
        'on'
      when FalseClass
        'off'
      when nil
        nil
      else
        v.to_s
      end
    end

    def self.configuration_attribute(name, values, prefix)
      if values.kind_of?(Hash)
        values = values.sort.map { |k, v| "#{k} #{v}" }
      end
      values = [ values ].flatten
      values.map do |value|
        final_name = attribute_name(name, prefix)
        final_value = attribute_value(value)

        # Some fixes:
        # avoid loading already loaded modules
        if final_name == 'LoadModule'
          next if module_compiled_in?(final_value)
          final_value = module_name_fix(final_value)
        end
        # add double quotes to some string-type attributes
        final_value = string_quotes_fix(final_name, final_value)

        # return the final configuration string
        '%-30s %s' % [ final_name, final_value ]
      end.compact.join("\n")
    end

    def self.configuration_block(block_name, name, conf, prefix=nil)
      template = <<-EOT

<<%= @block.capitalize %><%= " \#{@name}" unless @name.nil?  %>>
<% @conf.sort.each do |key, value| -%>
<%=  ProFTPD::Conf.attribute(key, value, @prefix).gsub(/^/, '  ') %>
<% end -%>
</<%= @block.capitalize %>>
      EOT

      eruby = Erubis::Eruby.new(template)
      eruby.evaluate(
        :block => block_name,
        :name => name,
        :prefix => prefix,
        :conf => conf,
        :ProFTPD_Conf => ProFTPD::Conf
      )
    end

    def self.configuration_block_list(block_name, conf, prefix=nil)
      conf.sort.map do |name, conf|
        # fix module name if needed
        if block_name == 'IfModule'
          name = module_name_fix(name)
          conf = conf.to_hash # Node attributes are read-only error fix
          prefix = conf.has_key?('prefix') ? conf.delete('prefix') : nil
        end
        configuration_block(block_name, name, conf, prefix)
      end.reject { |c| c.nil? or c.empty? }.join("\n")
    end

    def self.attribute(name, values, prefix=nil)
      name = underscore2camel(name)
      case name
      when 'Global', 'IfAuthenticated'
        configuration_block(name, nil, values)
      when 'Directory', 'VirtualHost', 'Anonymous', 'Limit'
        configuration_block_list(name, values, prefix)
      when 'IfModule', 'IfClass', 'IfGroup', 'IfUser'
        configuration_block_list(name, values, prefix)
      else
        configuration_attribute(name, values, prefix)
      end
    end

    def self.to_s(conf)
      conf.sort.map do |name, values|
        attribute(name, values)
      end.reject { |c| c.nil? or c.empty? }.join("\n")
    end

  end
end
