require "spec_helper"

describe RSpec::Cheki do
  it "has a version number" do
    expect(RSpec::Cheki::VERSION).not_to be nil
  end

  it "says cheese!" do
    expect("foo\nbar\nbaz\n").to say_cheese
  end
end
