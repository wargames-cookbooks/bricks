# This source file is part of Bricks's chef cookbook.
#
# Bricks's chef cookbook is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Bricks's chef cookbook is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Bricks's chef cookbook. If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.
#
# Cookbook Name:: bricks
# Recipe:: default
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
  raise ArgumentError, "Bricks's codename must be `raidak`, `lachen`, `punpun`, `torsa`, `feni`, `betwa` or `narmada`."
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
