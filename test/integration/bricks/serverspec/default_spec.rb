require "spec_helper"

describe "bricks::default" do
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
