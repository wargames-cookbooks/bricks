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
# Cookbook Name:: bricks_test
# Recipe:: default
#

describe "bricks_test::default" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it 'bricks vhost' do
    file(node["apache"]["dir"] + "/sites-available/bricks.conf").must_exist
  end

  it 'bricks vhost enabled' do
    file(node["apache"]["dir"] + "/sites-enabled/bricks.conf").must_exist
  end

  it 'docroot created' do
    directory(node["bricks"]["path"]).must_exist
  end
end
