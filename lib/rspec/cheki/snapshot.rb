require "yaml"

module RSpec
  module Cheki
    class Snapshot
      attr_reader :key
      attr_accessor :expected, :actual

      # @param [String] key The key
      def initialize key
        @key = key
      end

      # @return [boolean] true if the snapshot is stored
      def new?
        expected.nil?
      end

      # @return [boolean] true if the snapshot changed
      def changed?
        actual != expected
      end
    end
  end
end
