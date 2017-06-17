module RSpec
  module Cheki
    class SnapFile
      # TODO: Should be confugurable
      SNAPSHOTS_DIRNAME = "__snapshots__"
      SNAPSHOTS_FILE_EXT = ".yml.snap"

      class << self
        # Creata SnapFile instance from example object
        # @param [RSpec::Core::Example] example The example
        # @return [RSpec::Cheki::SnapFile] The SnapFile object
        def create(example:)
          SnapFile.new(example.file_path).tap do |file|
            file.create_snapshots_file
            file.load
          end
        end
      end

      attr_reader :spec_path, :dirname, :file_path, :snapshots

      # @param [String] spec_path The sepc file path
      def initialize spec_path
        init_paths spec_path
        @snapshots = {}
      end

      # Load snapshots file
      def load
        @yaml = YAML.load(File.read(file_path)) || {}
      end

      # Save snapshots to file
      # @param update [boolean] Save updated snapshots if true
      def save(update: false)
        snapshots.each do |key, s|
          @yaml[key] = (s.new? && s.changed?) ? s.actual : s.expected
        end
        File.write(file_path, YAML.dump(@yaml))
      end

      # Create the snapshot object from a stored snapshots file
      # @param [String] key The snapshot key
      # @return [RSpec::Cheki::Snapshot] snapshot The snapshot
      def create_snapshot key
        fail SnapshotsFileNotLoadedError if @yaml.nil?
        Snapshot.new(key).tap do |s|
          s.expected = @yaml[s.key] if @yaml.key? s.key
          snapshots[s.key] = s
        end
      end

      # @return [boolean] true if the snapshots file has not been existed
      def exists?
        File.exist? file_path
      end

      # Create the snapshots directory and the file
      def create_snapshots_file
        unless exists?
          FileUtils.mkdir dirname unless File.exist? dirname
          FileUtils.touch file_path
        end
      end

      private

      def init_paths spec_rel_path
        @spec_path = File.expand_path spec_rel_path
        basename = "#{File.basename spec_path}#{SNAPSHOTS_FILE_EXT}"
        @dirname = File.join(File.dirname(spec_path), SNAPSHOTS_DIRNAME)
        @file_path = File.join(dirname, basename)
      end
    end
  end
end
