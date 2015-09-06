# encoding: UTF-8
#
# Cookbook Name:: onddo_proftpd
# Library:: conf
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

module ProFTPD
  # Helper module to generate the main configuration file
  module Conf
    # Templates for configuration structures
    module Templates
      unless defined?(ProFTPD::Conf::Templates::CONFIGURATION_BLOCK)
        CONFIGURATION_BLOCK = <<-EOT

<<%= @block.capitalize %><%= " \#{@name}" unless @name.nil? %>>
<% @conf.sort.each do |key, value| -%>
<%=  ProFTPD::Conf.attribute(key, value, @prefix).gsub(/^/, '  ') %>
<% end -%>
</<%= @block.capitalize %>>
        EOT
      end
    end

    # First match wins!
    # Use alphabet letters to reference matches: a (first match), b, c
    ATTRIBUTE_NAMES_REGEXP = {
      /^(.*)Acls$/ =>        '%{a}ACLs',
      /^CdP(.*)$/ =>         'CDP%{a}',
      /^(.*)Cpu$/ =>         '%{a}CPU',
      /^(.*)Dn$/ =>          '%{a}DN',
      /^(.*)Dns$/ =>         '%{a}DNS',
      /^(.*)Gid(.*)$/ =>     '%{a}GID%{b}',
      /^(.*)Gmt$/ =>         '%{a}GMT',
      /^(.*)Ipv6$/ =>        '%{a}IPv6',
      /^Ldap(.*)$/ =>        'LDAP%{a}',
      /^(.*)Pam$/ =>         '%{a}PAM',
      /^(.*)PamConfig$/ =>   '%{a}PAMConfig',
      /^(.*)Rfc([0-9]+)$/ => '%{a}RFC%{b}',
      /^Sql(.*)$/ =>         'SQL%{a}',
      /^Sql(.*)$/ =>         'SQL%{a}',
      /^Tcp(.*)$/ =>         'TCP%{a}',
      /^(.*)Tls$/ =>         '%{a}TLS',
      /^TlsCa(.*)$/ =>       'TLSCA%{a}',
      /^TlsDh(.*)$/ =>       'TLSDH%{a}',
      /^TlsDsa(.*)$/ =>      'TLSDSA%{a}',
      /^TlsRsa(.*)$/ =>      'TLSRSA%{a}',
      /^Tls(.*)$/ =>         'TLS%{a}',
      /^(.*)Uid(.*)$/ =>     '%{a}UID%{b}',
      /^(.*)Utf8$/ =>        '%{a}UTF8',
      /^Vroot(.*)$/ =>       'VRoot%{a}'
    } unless defined?(ProFTPD::Conf::ATTRIBUTE_NAMES_REGEXP)

    # rubocop:disable Style/ClassVars

    @@compiled_in_modules = []
    def self.compiled_in_modules(mods)
      @@compiled_in_modules = mods if mods.is_a?(Array)
    end

    def self.module_compiled_in?(mod)
      mod = (mod =~ /^mod_(.+).c$/ ? Regexp.last_match[1] : mod).downcase
      @@compiled_in_modules.include?(mod.to_s.downcase)
    end

    # rubocop:enable Style/ClassVars

    # not used
    def self.camel2underscore(str)
      str.gsub(/([^A-Z])([A-Z])/, '\1_\2').downcase
    end

    def self.underscore2camel(str)
      str.split('_').map(&:capitalize).join
    end

    def self.string_quotes_fix(name, value)
      string_names = %w(
        AccessDenyMsg
        AccessGrantMsg
        LDAPServer
        ServerAdmin
        ServerName
        StoreUniquePrefix
      )
      string_names.include?(name) && value !~ /"/ ? "\"#{value}\"" : value
    end

    def self.module_name_fix(name)
      "mod_#{name}.c" if name !~ /^mod_.*\.c$/
    end

    def self.attribute_name_replace(matches, replace)
      abc = (:a..:z).to_a
      # Create an alphabet hash like {a: 'Multiline', b: '2228'} with matches
      args = matches.each_with_object({}) { |m, hs| hs[abc.shift] = m }
      format(replace, args)
    end

    # Fix some camelcase conversions
    def self.attribute_name(name, prefix)
      regexs = Hash[ATTRIBUTE_NAMES_REGEXP.to_a.reverse] # reverse the hash
      prefix.to_s + regexs.reduce(name.to_s) do |memo, (regex, replace)|
        if regex.match(name) # last match wins
          attribute_name_replace(Regexp.last_match.to_a.drop(1), replace)
        else
          memo
        end
      end
    end

    def self.attribute_value(v)
      case v
      when Array then v.map { |x| attribute_value(x) }.join(' ')
      when TrueClass then 'on'
      when FalseClass then 'off'
      when nil then nil
      else
        v.to_s
      end
    end

    def self.configuration_attribute_values_to_ary(values)
      values = values.sort.map { |k, v| "#{k} #{v}" } if values.is_a?(Hash)
      [values].flatten
    end

    def self.configuration_attribute(name, values, prefix)
      configuration_attribute_values_to_ary(values).map do |value|
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
        format('%-30s %s', final_name, final_value)
      end.compact.join("\n")
    end

    def self.configuration_block(block_name, name, conf, prefix = nil)
      template = ProFTPD::Conf::Templates::CONFIGURATION_BLOCK
      eruby = Erubis::Eruby.new(template)
      eruby.evaluate(
        block: block_name,
        name: name,
        prefix: prefix,
        conf: conf
      )
    end

    def self.configuration_block_list(block_name, confs, prefix = nil)
      result_r = confs.sort.map do |name, conf|
        # fix module name if needed
        if block_name == 'IfModule'
          name = module_name_fix(name)
          conf = conf.to_hash # Node attributes are read-only error fix
          prefix = conf.key?('prefix') ? conf.delete('prefix') : nil
        end
        configuration_block(block_name, name, conf, prefix)
      end
      result_r.reject { |c| c.nil? || c.empty? }.join("\n")
    end

    def self.attribute(name, values, prefix = nil)
      name = underscore2camel(name)
      case name
      when 'Global', 'IfAuthenticated'
        configuration_block(name, nil, values)
      when 'Directory', 'VirtualHost', 'Anonymous', 'Limit',
           'IfModule', 'IfClass', 'IfGroup', 'IfUser'
        configuration_block_list(name, values, prefix)
      else
        configuration_attribute(name, values, prefix)
      end
    end

    def self.to_s(conf = nil)
      return self.class.name if conf.nil?
      result_r = conf.sort.map { |name, values| attribute(name, values) }
      result_r.reject { |c| c.nil? || c.empty? }.join("\n")
    end
  end
end
