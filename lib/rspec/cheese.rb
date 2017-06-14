require "rspec/cheese/version"
require "rspec/cheese/snapshot"
require "rspec/cheese/matchers"

module RSpec
  module Cheese
    RSpec.configure do |config|
      config.include Matchers
    end
  end
end
