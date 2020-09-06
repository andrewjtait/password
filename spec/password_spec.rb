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

  describe "lowercase" do
    it "returns a password with an exact number of lowercase characters" do
      password = Password.generate(lowercase: 5)
      _(password).must_equal "T9k1SEg70rIjx65"
    end

    it "returns a password with zero lowercase characters" do
      password = Password.generate(lowercase: 0)
      _(password).must_equal "9WI803^1J74Q@!&"
    end
  end

  describe "uppercase" do
    it "returns a password with an exact number of uppercase characters" do
      password = Password.generate(uppercase: 5)
      _(password).must_equal "U9k1TEg70rJIx65"
    end

    it "returns a password with zero uppercase characters" do
      password = Password.generate(uppercase: 0)
      _(password).must_equal "9wi803^1j74q@!&"
    end
  end

  describe "numbers" do
    it "returns a password with an exact number of number characters" do
      password = Password.generate(numbers: 5)
      _(password).must_equal "1gkEUT5KrJIx609"
    end

    it "returns a password with zero number characters" do
      password = Password.generate(numbers: 0)
      _(password).must_equal "VwiIJT^PjSEq@!&"
    end
  end

  describe "special" do
    it "returns a password with an exact number of special characters" do
      password = Password.generate(special: 5)
      _(password).must_equal "U#k@TEgK!rJIx&^"
    end

    it "returns a password with zero special characters" do
      password = Password.generate(special: 0)
      _(password).must_equal "VwiIJT9PjSEq061"
    end
  end

  describe "multiple options" do
    it "returns a password supporting all options" do
      password = Password.generate(length: 12, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      _(password).must_equal "9r*4XG&Rp8$d"
    end

    it "raises an error if options conflict with length" do
      _(proc {
        Password.generate(length: 11, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      }).must_raise StandardError
    end
  end
end
