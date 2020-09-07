require "minitest/autorun"
require "password"

describe Password do
  UPPERCASE = %r([A-Z])
  LOWERCASE = %r([a-z])
  NUMBERS = %r([0-9])
  SPECIAL = %r([@%!?*^&])

  describe "length" do
    it "returns a password with default of 15 characters" do
      srand(5)
      password = Password.generate
      _(password).must_equal "P?H^MQj^*%eHQi@"
    end

    it "returns a password with a custom length" do
      password = Password.generate(length: 30)
      _(password.length).must_equal 30
    end

    it "allows passwords to be longer than the default based on other options" do
      password = Password.generate(special: 30)
      _(password.length).must_equal 30
      _(password.scan(SPECIAL).length).must_equal 30
    end

    it "returns the length of user defined options if all are defined" do
      password = Password.generate(lowercase: 2, uppercase: 0, numbers: 0, special: 0)
      _(password.length).must_equal 2
      _(password.scan(LOWERCASE).length).must_equal 2
    end
  end

  describe "lowercase" do
    it "returns a password with an exact number of lowercase characters" do
      password = Password.generate(lowercase: 5)
      _(password.length).must_equal 15
      _(password.scan(LOWERCASE).length).must_equal 5
    end

    it "returns a password with zero lowercase characters" do
      password = Password.generate(lowercase: 0)
      _(password.length).must_equal 15
      _(password.scan(LOWERCASE).length).must_equal 0
    end
  end

  describe "uppercase" do
    it "returns a password with an exact number of uppercase characters" do
      password = Password.generate(uppercase: 5)
      _(password.length).must_equal 15
      _(password.scan(UPPERCASE).length).must_equal 5
    end

    it "returns a password with zero uppercase characters" do
      password = Password.generate(uppercase: 0)
      _(password.length).must_equal 15
      _(password.scan(UPPERCASE).length).must_equal 0
    end
  end

  describe "numbers" do
    it "returns a password with an exact number of number characters" do
      password = Password.generate(numbers: 5)
      _(password.length).must_equal 15
      _(password.scan(NUMBERS).length).must_equal 5
    end

    it "returns a password with zero number characters" do
      password = Password.generate(numbers: 0)
      _(password.length).must_equal 15
      _(password.scan(NUMBERS).length).must_equal 0
    end
  end

  describe "special" do
    it "returns a password with an exact number of special characters" do
      password = Password.generate(special: 5)
      _(password.length).must_equal 15
      _(password.scan(SPECIAL).length).must_equal 5
    end

    it "returns a password with zero special characters" do
      password = Password.generate(special: 0)
      _(password.length).must_equal 15
      _(password.scan(SPECIAL).length).must_equal 0
    end
  end

  describe "multiple options" do
    it "returns a password supporting all options" do
      password = Password.generate(length: 12, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      _(password.length).must_equal 12
      _(password.scan(LOWERCASE).length).must_equal 3
      _(password.scan(UPPERCASE).length).must_equal 3
      _(password.scan(NUMBERS).length).must_equal 3
      _(password.scan(SPECIAL).length).must_equal 3
    end
  end

  describe "validation" do
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

    it "raises an error if an option is higher than length" do
      _(proc {
        Password.generate(length: 10, lowercase: 11)
      }).must_raise Password::InvalidOptionsError
    end

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
