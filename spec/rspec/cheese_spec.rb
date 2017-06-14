require "spec_helper"

describe Rspec::Cheese do
  it "has a version number" do
    expect(Rspec::Cheese::VERSION).not_to be nil
  end

  it 'generates snapshot' do
    path = File.join(File.dirname(__FILE__), "__snapshots__", "cheese_spec.rb.yaml.snap")
    snapshots = File.exists?(path) ? YAML.load(File.read(path)) : {}
    expect(snapshots[RSpec.current_example.id]).to say_cheese
  end
end
