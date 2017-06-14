require "spec_helper"

describe Rspec::Cheese do
  it "has a version number" do
    expect(Rspec::Cheese::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
