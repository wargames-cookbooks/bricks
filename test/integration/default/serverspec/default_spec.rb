# -*- coding: utf-8 -*-

require 'serverspec'
set :backend, :exec

describe service 'apache2' do
  it { should be_enabled }
  it { should be_running }
end

describe port 80 do
  it { should be_listening }
end

describe file '/etc/apache2/sites-available/bricks.conf' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file '/etc/apache2/sites-enabled/bricks.conf' do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_linked_to '/etc/apache2/sites-available/bricks.conf' }
end

describe file '/opt/bricks' do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end
