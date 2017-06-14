module RSpec
  module Cheese
    module Matchers
      class MatchSnapshot
        attr_reader :expected, :actual, :example, :snapshot

        def initialize
          @example = RSpec.current_example
          @snapshot = Snapshot.create(example: example)
        end

        def failure_message
          "received value does not match stored snapshot #{snapshot.key}"
        end

        def description
          "match stored snapshot"
        end

        def matches?(actual)
          @expected = snapshot.data
          @actual = actual

          pass = (actual == expected)

          if snapshot.added?
            snapshot.save @actual
            RSpec.configuration.reporter.message "Generate #{snapshot.snapshots_path}"
          end

          pass
        end

        def diffable?
          true
        end
      end
    end
  end
end
