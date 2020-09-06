require "minitest/autorun"
require "password"

describe Password do
  before do
    srand(5)
  end

  it "returns a password with 15 characters" do
    password = Password.generate
    _(password).must_equal "O0e8IRq5jXUiSH@"
  end

  describe "length" do
    it "returns a password with a custom length" do
      password = Password.generate(length: 30)
      _(password).must_equal "!6IXB2LV$qi8YZP7TH1S3j4R#GEJw@"
    end
  end
end
