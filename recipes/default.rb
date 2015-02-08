# -*- coding: utf-8 -*-
#
# Cookbook Name:: bricks
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

codename_map = {
  tuivai: 'http://downloads.sourceforge.net/project/owaspbricks/Tuivai%20-%202.2/OWASP%20Bricks%20-%20Tuivai.zip',
  mora: 'http://downloads.sourceforge.net/project/owaspbricks/Mora%20-%202.1/OWASP%20Bricks%20-%20Mora.zip',
  dakatua: 'http://downloads.sourceforge.net/project/owaspbricks/Dakatua%20-%202.0/OWASP%20Bricks%20-%20Dakatua.zip',
  barak: 'http://downloads.sourceforge.net/project/owaspbricks/Barak%20-%201.9/OWASP%20Bricks%20-%20Barak.zip',
  atrai: 'http://downloads.sourceforge.net/project/owaspbricks/Atrai%20-%201.8/OWASP%20Bricks%20-%20Atrai.zip',
  phalgu: 'http://downloads.sourceforge.net/project/owaspbricks/Phalgu%20-%201.7/OWASP%20Bricks%20-%20Phalgu.zip'
}

unless codename_map.key?(node['bricks']['codename'].to_sym)
  fail ArgumentError, "Invalid bricks codename: #{node['bricks']['codename']}"
end

package 'unzip'

include_recipe 'apache2'
include_recipe 'apache2::mod_php5'
include_recipe 'php'
include_recipe 'php::module_mysql'

remote_file "#{Chef::Config[:file_cache_path]}/bricks.zip" do
  source codename_map[node['bricks']['codename'].to_sym]
end

directory node['bricks']['path'] do
  recursive true
end

execute 'unzip-bricks' do
  cwd Chef::Config[:file_cache_path]
  command 'unzip -u bricks.zip'
end

execute 'copy-bricks-source' do
  cwd Chef::Config[:file_cache_path]
  command "cp -rf bricks/* #{node['bricks']['path']}"
end

template "#{node['bricks']['path']}/LocalSettings.php" do
  source 'LocalSettings.php.erb'
  owner 'www-data'
  group 'www-data'
  variables db: node['bricks']['db'],
            server: "http://#{node['bricks']['server_name']}",
            host: 'localhost',
            showhint: node['bricks']['showhint'].to_s
end

# Apache2 configuration
apache_site 'default' do
  enable false
end

web_app 'bricks' do
  enable true
  docroot node['bricks']['path']
  server_name node['bricks']['server_name']
  server_aliases node['bricks']['server_aliases']
end

# MySQL configuration
connection_info = {
  host: '127.0.0.1',
  username: 'root',
  password: 'toor',
  socket: '/run/mysql-default/mysqld.sock'
}

package 'libmysqlclient-dev'
gem_package 'mysql2'

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password 'toor'
  action [:create, :start]
end

mysql_database 'drop-bricks-db' do
  connection connection_info
  database_name node['bricks']['db']['name']
  action :drop
end

mysql_database 'create-bricks-db' do
  connection connection_info
  database_name node['bricks']['db']['name']
end

mysql_database_user node['bricks']['db']['username'] do
  connection connection_info
  password node['bricks']['db']['password']
  database_name node['bricks']['db']['name']
  privileges [:select, :update, :insert, :create, :delete, :drop]
  action :grant
end

mysql_database 'populate-bricks-db' do
  connection connection_info
  database_name node['bricks']['db']['name']
  sql { ::File.open("#{node['bricks']['path']}/config/bricks.sql").read }
  action :query
end
