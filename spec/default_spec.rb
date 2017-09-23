# -*- coding: utf-8 -*-

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'bricks' }

require 'chef/application'

describe 'bricks::default' do
  before do
    stub_command('/usr/sbin/apache2 -t').and_return(true)
  end

  let(:subject) do
    ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache',
                             platform: 'debian',
                             version: '9.0') do |node|
      node.override['apache']['mpm'] = 'prefork'
      node.override['bricks']['codename'] = :phalgu
      node.override['bricks']['server_name'] = 'bricks-server'
      node.override['bricks']['showhint'] = true
      node.override['bricks']['path'] = '/opt/bricks-app'
      node.override['bricks']['db']['username'] = 'bricksuser'
      node.override['bricks']['db']['password'] = 'brickspass'
      node.override['bricks']['db']['name'] = 'bricksdb'
    end.converge(described_recipe)
  end

  it 'should install unzip package' do
    expect(subject).to install_package('unzip')
  end

  it 'should include required recipes for webapp' do
    expect(subject).to include_recipe('apache2')
    expect(subject).to include_recipe('apache2::mod_php')
    expect(subject).to include_recipe('php')
    expect(subject).to include_recipe('php::module_mysql')
  end

  it 'should download bricks zip file' do
    expect(subject).to create_remote_file('/var/chef/cache/bricks.zip')
      .with(source: 'http://downloads.sourceforge.net/project/owaspbricks/Phalgu%20-%201.7/OWASP%20Bricks%20-%20Phalgu.zip')
  end

  it 'should create bricks directory' do
    expect(subject).to create_directory('/opt/bricks-app')
  end

  it 'should unzip bricks archive' do
    expect(subject).to run_execute('unzip-bricks')
      .with(cwd: '/var/chef/cache',
            command: 'unzip -u bricks.zip')
  end

  it 'should copy bricks source code in bricks rootdir' do
    expect(subject).to run_execute('copy-bricks-source')
      .with(cwd: '/var/chef/cache',
            command: 'cp -rf bricks/* /opt/bricks-app')
  end

  it 'should create config file from template' do
    config_file = '/opt/bricks-app/LocalSettings.php'
    matches = [/^\$dbuser\s+=\s+'bricksuser';$/,
               /^\$dbpass\s+=\s+'brickspass';$/,
               /^\$dbname\s+=\s+'bricksdb';$/,
               /^\$host\s+=\s+'localhost';$/,
               /^\$showhint\s+=\s+true;$/,
               %r{^\$server\s+=\s+'http:\/\/bricks-server';$}]

    expect(subject).to create_template(config_file)
      .with(source: 'LocalSettings.php.erb',
            owner: 'www-data',
            group: 'www-data')

    matches.each do |m|
      expect(subject).to render_file(config_file).with_content(m)
    end
  end

  it 'should install mysql2 gem package' do
    expect(subject).to install_mysql2_chef_gem('default')
  end

  it 'should setup mysql service' do
    expect(subject).to create_mysql_service('default')
      .with(port: '3306',
            version: '5.5',
            initial_root_password: 'toor')
  end

  it 'should drop mysql database' do
    expect(subject).to drop_mysql_database('drop-bricks-db')
      .with(database_name: 'bricksdb',
            connection: { host: '127.0.0.1',
                          username: 'root',
                          password: 'toor',
                          socket: '/run/mysql-default/mysqld.sock' })
  end

  it 'should create mysql database' do
    expect(subject).to create_mysql_database('create-bricks-db')
      .with(database_name: 'bricksdb',
            connection: { host: '127.0.0.1',
                          username: 'root',
                          password: 'toor',
                          socket: '/run/mysql-default/mysqld.sock' })
  end

  it 'should create database user' do
    expect(subject).to grant_mysql_database_user('bricksuser')
      .with(password: 'brickspass',
            database_name: 'bricksdb',
            privileges: [:select, :update, :insert, :create, :delete, :drop],
            connection: { host: '127.0.0.1',
                          username: 'root',
                          password: 'toor',
                          socket: '/run/mysql-default/mysqld.sock' })
  end

  it 'should populate bricks database with mysql dump' do
    expect(subject).to run_execute('import-mysql-dump')
      .with(command: 'mysql -h 127.0.0.1 -u root -ptoor '\
                     '--socket /run/mysql-default/mysqld.sock '\
                     'bricksdb < /opt/bricks-app/config/bricks.sql')
  end
end
