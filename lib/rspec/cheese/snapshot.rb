require "yaml"

module RSpec
  module Cheese
    class Snapshot
      attr_reader :example, :data, :updated_content
      attr_accessor :expected, :actual

      # @param [RSpec::Core::Example] example The example
      def initialize example
        @example = example
      end

      # @return [boolean] true if the snapshot is stored
      def new?
        expected.nil?
      end

      # @return [boolean] true if the snapshot changed
      def changed?
        actual != expected
      end

      # @return [String] key The snapshot key
      def key
        # TODO: Support 1-testcase n-epectation
        example.id
      end
    end
  end
end
