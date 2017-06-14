require 'yaml'

module RSpec
  module Cheese
    class Snapshot
      # TODO: Confugurable
      SNAPSHOTS_DIRNAME = '__snapshots__'
      SNAPSHOTS_FILE_EXT = '.yml.snap'

      class << self
        def create(example:)
          Snapshot.new(example).tap do |snapshot|
            snapshot.create_snapshots_file_if_needed
            snapshot.load
          end
        end
      end

      attr_reader :example

      def initialize(example)
        @example = example
        @added = false
      end

      def load
        @yaml = YAML.load(File.read(snapshots_path)) || {}
      end

      def data
        @yaml[key]
      end

      def added?
        @added
      end

      def create_snapshots_file_if_needed
        unless snapshots_exists?
          create_snapshots_file
          @added = true
        end
      end

      def save(content)
        if added?
          @yaml[key] = content
          File.write(snapshots_path, YAML.dump(@yaml))
        end
      end

      def key
        # TODO: Support 1-testcase n-epectation
        example.id
      end

      def spec_filename
        File.basename(spec_path)
      end

      def snapshots_filename
        "#{spec_filename}#{SNAPSHOTS_FILE_EXT}"
      end

      def spec_path
        @spec_path = File.expand_path(example.file_path)
      end

      def snapshots_dirname
        @difname = File.join(File.dirname(spec_path), SNAPSHOTS_DIRNAME)
      end

      def snapshots_path
        @file_path = File.join(snapshots_dirname, snapshots_filename)
      end

      def snapshots_exists?
        File.exist?(snapshots_path)
      end

      private

      def create_snapshots_file
        unless File.exist? snapshots_dirname
          FileUtils.mkdir snapshots_dirname
        end
        FileUtils.touch snapshots_path
      end
    end
  end
end
