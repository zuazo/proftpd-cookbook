# encoding: UTF-8
#
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

require 'spec_helper'

describe 'onddo_proftpd::default' do
  let(:chef_runner) { ChefSpec::Runner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:node_set) { chef_runner.node.set }
  let(:node_automatic) { chef_runner.node.automatic }
  before do
    stub_command(
      "    grep -q 'start-stop-daemon --stop --signal $SIGNAL --quiet "\
      "--pidfile \"$PIDFILE\"$' /etc/init.d/proftpd\n"
    ).and_return(false)
    stub_command(
      "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}' "\
      "| cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
    ).and_return(true)
  end

  it 'should include onddo_proftpd::ohai_plugin recipe' do
    expect(chef_run).to include_recipe('onddo_proftpd::ohai_plugin')
  end

  %w(redhat centos amazon).each do |platform|
    context "in #{platform} platform" do
      before do
        node_automatic['platform'] = platform
      end

      it 'should include yum-epel cookbook' do
        expect(chef_run).to include_recipe('yum-epel')
      end

    end
  end # redhat centos amazon .each do |platform|

  %w(debian ubuntu).each do |platform|
    context "in #{platform} platform" do
      before do
        node_automatic['platform'] = platform
      end

      it 'should not include yum-epel cookbook' do
        expect(chef_run).to_not include_recipe('yum-epel')
      end

    end
  end # redhat centos amazon .each do |platform|

  %w(fedora).each do |platform|
    context "in #{platform} platform" do
      before do
        node_automatic['platform'] = platform
      end

      it 'should upgrade old versions of openssl' do
        stub_command(
          "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}'"\
          " | cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
        ).and_return(false)
        expect(chef_run).to upgrade_package('openssl')
      end

      it 'should not upgrade new versions of openssl' do
        stub_command(
          "file /usr/lib*/libcrypto.so.[0-9]* | awk '$2 == \"ELF\" {print $1}'"\
          " | cut -d: -f1 | xargs readelf -s | grep -Fwq 'OPENSSL_'"
        ).and_return(true)
        expect(chef_run).to_not upgrade_package('openssl')
      end

    end
  end # redhat centos amazon .each do |platform|

  it 'should install proftpd package' do
    expect(chef_run).to install_package('proftpd')
  end

  it 'proftpd package should notify ohai plugin' do
    resource = chef_run.package('proftpd')
    expect(resource).to notify('ohai[reload_proftpd]').to(:reload).immediately
  end

  module_packages = {
    redhat_centos_scientific_fedora_suse_amazon: {
      ldap: 'proftpd-ldap',
      sql_mysql: 'proftpd-mysql',
      sql_postgres: 'proftpd-postgresql'
    },
    debian_ubuntu: {
      autohost: 'proftpd-mod-autohost',
      case: 'proftpd-mod-case',
      clamav: 'proftpd-mod-clamav',
      dnsbl: 'proftpd-mod-dnsbl',
      fsync: 'proftpd-mod-fsync',
      geoip: 'proftpd-mod-geoip',
      ldap: 'proftpd-mod-ldap',
      msg: 'proftpd-mod-msg',
      sql_mysql: 'proftpd-mod-mysql',
      sql_odbc: 'proftpd-mod-odbc',
      sql_postgres: 'proftpd-mod-pgsql',
      sql_sqlite: 'proftpd-mod-sqlite',
      tar: 'proftpd-mod-tar'
    }
  }

  module_packages.each do |platforms, mods|
    platforms.to_s.split('_').each do |platform|
      context "in #{platform} platform" do
        let(:proftpd_conf) { node['proftpd']['conf'] }
        let(:proftpd_conf_set) { node_set['proftpd']['conf'] }
        before do
          node_automatic['platform'] = platform
          proftpd_conf_set['if_module']['dso']['load_module'] = []
        end

        mods.each do |mod, pkg|
          context "with #{mod} module enabled" do
            before do
              proftpd_conf_set['if_module']['dso']['load_module'] = [mod]
            end

            context 'without DSO' do
              it "should not install #{pkg} package" do
                expect(chef_run).to_not install_package(pkg)
              end
            end # context without DSO

            context 'with DSO' do
              before do
                modules = proftpd_conf['if_module']['dso']['load_module']
                proftpd_conf_set['if_module']['dso']['load_module'] =
                  modules + %w(dso)
              end

              it "should install #{pkg} package" do
                expect(chef_run).to install_package(pkg)
              end

              it "#{pkg} package should notify proftpd reload" do
                resource = chef_run.package(pkg)
                expect(resource).to notify('service[proftpd]')
                  .to(:reload).delayed
              end
            end # context with DSO
          end # context with #{mod} module enabled
        end # each do |mod, pkg|
      end # context in #{platform} platform
    end # each do |platform|
  end # each do |platforms, mods|

  it 'should create /etc/proftpd directory' do
    expect(chef_run).to create_directory('/etc/proftpd')
  end

  it 'should create included directory' do
    expect(chef_run).to create_directory('/etc/proftpd/conf.d')
  end

  it 'should create modules.conf file (required for Debian)' do
    expect(chef_run).to create_template('/etc/proftpd/modules.conf')
      .with_user('root')
      .with_group('root')
      .with_mode('00640')
  end

  it 'should create proftpd.conf file' do
    expect(chef_run).to create_template('/etc/proftpd/proftpd.conf')
      .with_user('root')
      .with_group('root')
      .with_mode('00640')
  end

  it 'proftpd.conf should notify proftpd service' do
    resource = chef_run.template('/etc/proftpd/proftpd.conf')
    expect(resource).to notify('service[proftpd]').to(:restart).delayed
  end

  it 'should create /etc/proftpd.conf link' do
    expect(chef_run).to create_link('/etc/proftpd.conf')
      .with_to('/etc/proftpd/proftpd.conf')
  end

  it '/etc/proftpd.conf link should notify proftpd service' do
    resource = chef_run.link('/etc/proftpd.conf')
    expect(resource).to notify('service[proftpd]').to(:restart).delayed
  end

  it 'should fix ubuntu 14.04 logrotate bug (1293416)' do
    stub_command(
      "    grep -q 'start-stop-daemon --stop --signal $SIGNAL --quiet "\
      "--pidfile \"$PIDFILE\"$' /etc/init.d/proftpd\n"
    ).and_return(true)
    expect(chef_run)
      .to run_execute('Fix for Ubuntu 14.04 proftpd+logrotate bug')
  end

  it 'logrotate bugfix should notify proftpd service' do
    stub_command(
      "    grep -q 'start-stop-daemon --stop --signal $SIGNAL --quiet "\
      "--pidfile \"$PIDFILE\"$' /etc/init.d/proftpd\n"
    ).and_return(true)
    resource = chef_run.execute('Fix for Ubuntu 14.04 proftpd+logrotate bug')
    expect(resource).to notify('service[proftpd]').to(:restart).delayed
  end

  it 'should not fix logrotate bug when not needed' do
    stub_command(
      "    grep -q 'start-stop-daemon --stop --signal $SIGNAL --quiet "\
      "--pidfile \"$PIDFILE\"$' /etc/init.d/proftpd\n"
    ).and_return(false)
    expect(chef_run)
      .not_to run_execute('Fix for Ubuntu 14.04 proftpd+logrotate bug')
  end

  it 'should enable proftpd service' do
    expect(chef_run).to enable_service('proftpd')
  end

  it 'should start proftpd service' do
    expect(chef_run).to start_service('proftpd')
  end

end
