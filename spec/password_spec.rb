require "minitest/autorun"
require "password"

describe Password do
  before do
    srand(5)
  end

  describe "length" do
    it "returns a password with default of 15 characters" do
      password = Password.generate
      _(password).must_equal "P?H^MQj^*%eHQi@"
    end

    it "returns a password with a custom length" do
      password = Password.generate(length: 30)
      _(password).must_equal "%P1HRHV%!4Q!q2MI9Q9j6M%@ENw&HQ"
    end

    it "allows passwords to be longer than the default based on other options" do
      password = Password.generate(special: 30)
      _(password).must_equal "*&^*&&&*@%%^@&^@?&%?@*^@?&!%?&"
    end

    it "returns the length of user defined options if all are defined" do
      password = Password.generate(lowercase: 2, uppercase: 0, numbers: 0, special: 0)
      _(password).must_equal "do"
    end
  end

  describe "lowercase" do
    it "returns a password with an exact number of lowercase characters" do
      password = Password.generate(lowercase: 5)
      _(password).must_equal "1gjE0Q?7qHiw5@7"
    end

    it "returns a password with zero lowercase characters" do
      password = Password.generate(lowercase: 0)
      _(password).must_equal "7*8%07W*@J04Q^?"
    end
  end

  describe "uppercase" do
    it "returns a password with an exact number of uppercase characters" do
      password = Password.generate(uppercase: 5)
      _(password).must_equal "1gJE0Q?7qHIw5@7"
    end

    it "returns a password with zero uppercase characters" do
      password = Password.generate(uppercase: 0)
      _(password).must_equal "7*8%07w*@j04q^?"
    end
  end

  describe "numbers" do
    it "returns a password with an exact number of number characters" do
      password = Password.generate(numbers: 5)
      _(password).must_equal "1gJE0Q?7qHIw5@7"
    end

    it "returns a password with zero number characters" do
      password = Password.generate(numbers: 0)
      _(password).must_equal "H*I%QHw*@jQEq^?"
    end
  end

  describe "special" do
    it "returns a password with an exact number of special characters" do
      password = Password.generate(special: 5)
      _(password).must_equal "*gJE0Q?7qHIw%@^"
    end

    it "returns a password with zero special characters" do
      password = Password.generate(special: 0)
      _(password).must_equal "HEI4QHw0q571j1Q"
    end
  end

  describe "multiple options" do
    it "returns a password supporting all options" do
      password = Password.generate(length: 12, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      _(password).must_equal "9p4&WG@?Qo8d"
    end

    it "raises an error if options total is higher than length" do
      _(proc {
        Password.generate(length: 11, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      }).must_raise Password::InvalidOptionsError
    end

    it "raises an error if options total is lower than length" do
      _(proc {
        Password.generate(length: 13, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      }).must_raise Password::InvalidOptionsError
    end
  end

  describe "validation" do
    it "raise an error for any invalid length value" do
      _(proc {
        Password.generate(length: 0)
      }).must_raise Password::InvalidOptionsError

      _(proc {
        Password.generate(length: "not a number")
      }).must_raise Password::InvalidOptionsError
    end


    it "raise an error for any invalid character count values" do
      _(proc {
        Password.generate(lowercase: -1)
      }).must_raise Password::InvalidOptionsError

      _(proc {
        Password.generate(special: "not a number")
      }).must_raise Password::InvalidOptionsError
    end
  end
end
