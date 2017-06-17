require "rspec/cheki/errors"
require "rspec/cheki/manager"
require "rspec/cheki/matchers"
require "rspec/cheki/snap_file"
require "rspec/cheki/snapshot"
require "rspec/cheki/version"

module RSpec
  module Cheki
  end
end

RSpec.configure do |config|
  config.include RSpec::Cheki::Matchers

  config.add_setting RSpec::Cheki::Manager.settings_name, default: RSpec::Cheki::Manager.new

  config.after :suite do
    # TODO: update snapshot if needed
  end
end
