require "rspec/cheese/errors"
require "rspec/cheese/manager"
require "rspec/cheese/matchers"
require "rspec/cheese/snap_file"
require "rspec/cheese/snapshot"
require "rspec/cheese/version"

module RSpec
  module Cheese
  end
end

RSpec.configure do |config|
  config.include RSpec::Cheese::Matchers

  config.add_setting RSpec::Cheese::Manager.settings_name, default: RSpec::Cheese::Manager.new

  config.after :suite do
    # TODO: update snapshot if needed
  end
end
