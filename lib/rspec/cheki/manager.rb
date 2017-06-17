module RSpec
  module Cheki
    class Manager
      SETTINGS_UPDATED_SNAPSHOTS = :"rspec_cheki__updater"

      class << self
        # Create snapshot instance from example object
        # @param [RSpec::Core::Example] example The example
        # @return [RSpec::Cheki::Snapshot] The snapshot
        def create_snapshot(example:)
          instance.create_snapshot(example)
        end

        # @return [String] The settings name
        def settings_name
          SETTINGS_UPDATED_SNAPSHOTS
        end

        # Save snapshots to file
        # @param update [boolean] Save updated snapshots if true
        def update(update: false)
          instance.save(update: update)
        end

        private

        def instance
          RSpec.configuration.send(settings_name)
        end
      end

      attr_reader :files

      def initialize
        @files = {}
      end

      # Create snapshot instance from example object
      # @param [RSpec::Core::Example] example The example
      # @return [RSpec::Cheki::Snapshot] The snapshot
      def create_snapshot example
        key = example.file_path
        @files[key] = SnapFile.create(example: example) unless @files.key? key
        @files[key].create_snapshot(example.id)
      end

      # Save snapshots to file
      # @param update [boolean] Save updated snapshots if true
      def save(update: false)
        @files.each { |_, f| f.save(update: update) }
      end
    end
  end
end
