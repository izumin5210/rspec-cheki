require "yaml"

module RSpec
  module Cheki
    class Snapshot
      attr_reader :key, :expected, :actual

      # @param [String] key The key
      def initialize key
        @key = key
        @expected_updated = false
        @actual_updated = false
      end

      # @return [boolean] true if the actual value is equal to stored value from snapshot
      def match?
        actual == expected
      end

      # @return [boolean] true if the snapshot is stored
      def new?
        !@expected_updated
      end

      # @return [boolean] true if the snapshot changed
      def needs_update?
        @actual_updated && !match?
      end

      def expected= value
        @expected_updated = true
        @expected = value
      end

      def actual= value
        @actual_updated = true
        @actual = value
      end
    end
  end
end
