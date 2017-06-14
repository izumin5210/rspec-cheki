require "spec_helper"

describe RSpec::Cheese::Matchers::MatchSnapshot do
  let(:example) { RSpec.current_example }
  let(:spec_path) { File.expand_path(example.file_path) }
  let(:spec_dirname) { File.dirname(spec_path) }
  let(:spec_basename) { File.basename(spec_path) }
  let(:snapshots_dirname) { File.join(spec_dirname, "__snapshots__") }
  let(:snapshots_basename) { "#{spec_basename}.yaml.snap" }
  let(:snapshots_path) { File.join(snapshots_dirname, snapshots_basename) }
  let(:matcher) { RSpec::Cheese::Matchers::MatchSnapshot.new }

  let(:snapshots_dir_exists?) { true }
  let(:snapshots_file_exists?) { true }
  let(:snapshots_file_content) { "" }

  let(:expected) { "foo\nbar\nbaz\n" }
  subject { matcher.matches?(expected) }

  before do
    allow(File).to receive(:exist?).with(snapshots_dirname).and_return(snapshots_dir_exists?)
    allow(File).to receive(:exist?).with(snapshots_path).and_return(snapshots_file_exists?)
    allow(File).to receive(:read).with(snapshots_path).and_return(snapshots_file_content)
  end

  it { expect(matcher).to be_diffable }

  context "when the snapshot directory has not existed" do
    let(:snapshots_dir_exists?) { false }
    let(:snapshots_file_exists?) { false }

    it "creates __snapshots__ directory and file" do
      expect(FileUtils).to receive(:mkdir).with(snapshots_dirname)
      expect(FileUtils).to receive(:touch).with(snapshots_path)
      expect(File).to receive(:write)
      is_expected.to be false
    end
  end

  context "when the snapshots file has not existed" do
    let(:snapshots_file_exists?) { false }

    it "creates __snapshots__ directory and file" do
      expect(FileUtils).to_not receive(:mkdir)
      expect(FileUtils).to receive(:touch).with(snapshots_path)
      expect(File).to receive(:write)
      is_expected.to be false
    end
  end

  context "when the snapshot has not existed" do
    let(:snapshots_file_content) do
      <<~YAML
      ---
      YAML
    end

    it "creates __snapshots__ directory and file" do
      expect(FileUtils).to_not receive(:mkdir)
      expect(FileUtils).to_not receive(:touch)
      is_expected.to be false
    end
  end

  context "when the snapshot has already existed" do
    let(:snapshots_file_content) do
      <<~YAML
      ---
      "#{example.id}": |
        foo
        bar
        baz
      YAML
    end

    it do
      expect(FileUtils).to_not receive(:mkdir)
      expect(FileUtils).to_not receive(:touch)
      expect(File).to_not receive(:write)
      is_expected.to be true
    end
  end
end
