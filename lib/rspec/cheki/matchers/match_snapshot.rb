module RSpec
  module Cheki
    module Matchers
      class MatchSnapshot
        attr_reader :example, :snapshot

        extend Forwardable
        def_delegators :snapshot, :expected, :actual

        def initialize
          @example = RSpec.current_example
          @snapshot = RSpec::Cheki::Manager.create_snapshot(example: example)
        end

        def failure_message
          "received value does not match stored snapshot #{snapshot.key}"
        end

        def description
          "match stored snapshot"
        end

        def matches?(actual)
          snapshot.actual = actual
          !snapshot.changed?
        end

        def diffable?
          true
        end
      end
    end
  end
end
