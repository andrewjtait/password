require "minitest/autorun"
require "password"

describe Password do
  it "returns a password" do
    _(Password.generate).must_equal "password"
  end
end
