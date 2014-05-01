# encoding: utf-8
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

include_recipe "apache2"
include_recipe "php"
include_recipe "apache2::mod_php5"
include_recipe "php::module_mysql"
include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "mysql::ruby"
include_recipe "database"

# Install the unzip package
package "unzip" do
  action :install
end

# Bricks Install
case node["bricks"]["codename"]
when "barak"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Barak%20-%201.9/OWASP%20Bricks%20-%20Barak.zip"
when "atrai"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Atrai%20-%201.8/OWASP%20Bricks%20-%20Atrai.zip"
when "phalgu"
  dl_url = "http://sourceforge.net/projects/owaspbricks/files/Phalgu%20-%201.7/OWASP%20Bricks%20-%20Phalgu.zip"
when "raidak"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Raidak%20-%201.6/OWASP%20Bricks%20-%20Raidak.zip"
when "lachen"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Lachen%20-%201.5/OWASP%20Bricks%20-%20Lachen.zip"
when "punpun"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Punpun%20-%201.4/OWASP%20Bricks%20-%20Punpun.zip"
when "torsa"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Torsa%20-%201.3/OWASP%20Bricks%20-%20Torsa.zip"
when "feni"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Feni%20-%201.2/OWASP%20Bricks%20-%20Feni.zip"
when "betwa"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Betwa%20-%201.1/OWASP%20Bricks%20-%20Betwa.zip"
when "narmada"
  dl_url = "http://downloads.sourceforge.net/project/owaspbricks/Narmada%20-%201.0/OWASP%20Bricks%20-%20Narmada.zip"
else
  raise ArgumentError, "Invalid bricks codename: " + node["bricks"]["codename"]
end

localfile = Chef::Config[:file_cache_path] + "/bricks.zip"

remote_file localfile do
  source dl_url
  mode "0644"
end

directory node["bricks"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "unzip-bricks" do
  cwd Chef::Config[:file_cache_path]
  command "unzip " + localfile
end

execute "move bricks source" do
  cwd Chef::Config[:file_cache_path]
  command "mv bricks/* " + node["bricks"]["path"]
end

template node['bricks']['path'] + '/LocalSettings.php' do
  source 'LocalSettings.php.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
            :server => 'http://bricks',
            :dbname => node["bricks"]["db"]["name"],
            :dbuser => node["bricks"]["db"]["username"],
            :dbpass => node["bricks"]["db"]["password"],
            :host => 'localhost',
            :showhint => false)
end

#Fix unix path for Raidak and older bricks's codenames
case node["bricks"]["codename"]
when "raidak","lachen","punpun","torsa","feni","betwa","narmada"
  cookbook_file "/tmp/fix_unix_path.sh" do
    source "fix_unix_path.sh"
    cookbook "bricks"
  end

  execute "chmod script" do
    command "chmod u+x /tmp/fix_unix_path.sh"
  end

  execute "fix unix path" do
    command "/tmp/fix_unix_path.sh " + node["bricks"]["path"]
  end
end

# Apache2 configuration
apache_site "default" do
  enable false
end

web_app "bricks" do
  cookbook "bricks"
  enable true
  docroot node["bricks"]["path"]
  server_name node["bricks"]["server_name"]
  server_aliases node["bricks"]["server_aliases"]
end

# MySQL configuration
mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

mysql_database node["bricks"]["db"]["name"] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node["bricks"]["db"]["username"] do
  connection mysql_connection_info
  password node["bricks"]["db"]["password"]
  database_name node["bricks"]["db"]["name"]
  privileges [:select,:update,:insert,:create,:delete,:drop]
  action :grant
end

mysql_database "Setup database" do
  connection mysql_connection_info
  database_name node["bricks"]["db"]["name"]
  sql { ::File.open(node["bricks"]["path"] + "/config/bricks.sql").read }
  action :query
end
