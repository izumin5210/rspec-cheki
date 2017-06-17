require "rspec/cheki/matchers/match_snapshot"

module RSpec
  module Cheki
    module Matchers
      def match_snapshot
        MatchSnapshot.new
      end
      alias_method :say_cheese, :match_snapshot
    end
  end
end
