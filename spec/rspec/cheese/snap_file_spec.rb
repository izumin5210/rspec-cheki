require "spec_helper"

describe RSpec::Cheese::SnapFile do
  include FakeFS::SpecHelpers
  before do
    FileUtils.mkdir_p spec_dirname
  end

  let(:example) { RSpec.current_example }
  let(:spec_file_path) { File.expand_path example.file_path }
  let(:spec_dirname) { File.dirname spec_file_path }
  let(:spec_basename) { File.basename spec_file_path }
  let(:snapshots_dirname) { File.join(spec_dirname, "__snapshots__") }
  let(:snapshots_basename) { "#{spec_basename}.yml.snap" }
  let(:snapshots_file_path) { File.join(snapshots_dirname, snapshots_basename) }
  let(:snap_file) { RSpec::Cheese::SnapFile.new(spec_file_path) }

  describe "#create_snapshot" do
    let(:snapshot) { snap_file.create_snapshot example.id }
    subject { snapshot }

    context "when the snapshots file is not loaded" do
      it { expect { subject }.to raise_error RSpec::Cheese::SnapshotsFileNotLoadedError }
    end

    context "when the snapshots file is loaded" do
      before do
        FileUtils.mkdir_p snapshots_dirname
        File.write(snapshots_file_path, file_content)
        snap_file.load
      end

      context "when the snapshot is not stored" do
        let(:file_content) do
          <<~YAML
          ---
          YAML
        end
        its(:new?) { is_expected.to be true }
      end

      context "when the snapshot is stored" do
        let(:file_content) do
          <<~YAML
          ---
          "#{example.id}": |
            foo
            bar
            baz
          YAML
        end
        its(:new?) { is_expected.to be false }
      end
    end
  end

  describe "#create_snapshot_file" do
    before { snap_file.create_snapshots_file }
    subject { File.exist?(snapshots_file_path) }

    context "when the snapshots directory does not exists" do
      it { is_expected.to be true }
    end

    context "when the snapshots file does not exists" do
      before do
        FileUtils.mkdir_p snapshots_dirname
      end

      it { is_expected.to be true }
    end

    context "when the snapshots file exists" do
      before do
        FileUtils.mkdir_p snapshots_dirname
        FileUtils.touch snapshots_file_path
      end

      it { is_expected.to be true }
    end
  end

  describe "#save" do
    let(:example_ids) { %w([1:1] [1:2] [2:1] [3:1]) }
    let(:file_content) do
      <<~YAML
      ---
      "#{example_ids[0]}": |
        foo
        bar
      "#{example_ids[1]}": 1
      "#{example_ids[3]}": true
      YAML
    end
    subject { File.read(snapshots_file_path) }

    before do
      FileUtils.mkdir_p snapshots_dirname
      File.write(snapshots_file_path, file_content)
      snap_file.load
      snapshots = example_ids.map { |id| snap_file.create_snapshot id }
      snapshots[0].actual = "foo\nbaz"
      snapshots[2].actual = "[1, 3, 5, 8]"
      snap_file.save(update: update)
    end

    context "when 'update' is set false" do
      let(:update) { false }
      let(:updated_snapshot_content) do
        <<~YAML
        ---
        "#{example_ids[0]}": |
          foo
          bar
        "#{example_ids[1]}": 1
        "#{example_ids[3]}": true
        "#{example_ids[2]}": "[1, 3, 5, 8]"
        YAML
      end

      it "should add only new snapshot" do
        is_expected.to eq updated_snapshot_content
      end
    end

    context "when 'update' is set true" do
      let(:update) { true }
      let(:updated_snapshot_content) do
        <<~YAML
        ---
        "#{example_ids[0]}": |
          foo
          bar
        "#{example_ids[1]}": 1
        "#{example_ids[3]}": true
        "#{example_ids[2]}": "[1, 3, 5, 8]"
        YAML
      end

      it "should add also updated snapshots" do
        is_expected.to eq updated_snapshot_content
      end
    end
  end
end
