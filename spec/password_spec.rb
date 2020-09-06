require "minitest/autorun"
require "password"

describe Password do
  before do
    srand(5)
  end

  describe "length" do
    it "returns a password with default of 15 characters" do
      password = Password.generate
      _(password).must_equal "mGJeqq*hQhiW!51"
    end

    it "returns a password with a custom length" do
      password = Password.generate(length: 30)
      _(password).must_equal "!6eql2qm*WJ@pvr4qn9h9Q1h^himG£"
    end

    it "allows passwords to be longer than the default based on other options" do
      password = Password.generate(special: 30)
      _(password).must_equal "%!%!@&$%%£@!&^&*!%^!*#!!£@$£**"
    end
  end

  describe "lowercase" do
    it "returns a password with an exact number of lowercase characters" do
      password = Password.generate(lowercase: 5)
      _(password).must_equal "7PQiqh*0WeJG!^1"
    end

    it "returns a password with zero lowercase characters" do
      password = Password.generate(lowercase: 0)
      _(password).must_equal "7pq807*0w49g!^@"
    end
  end

  describe "uppercase" do
    it "returns a password with an exact number of uppercase characters" do
      password = Password.generate(uppercase: 5)
      _(password).must_equal "7PQiqh*0WejG!^1"
    end

    it "returns a password with zero uppercase characters" do
      password = Password.generate(uppercase: 0)
      _(password).must_equal "7PQ807*0W49G!^@"
    end
  end

  describe "numbers" do
    it "returns a password with an exact number of number characters" do
      password = Password.generate(numbers: 5)
      _(password).must_equal "7PQi07*0WejG!^1"
    end

    it "returns a password with zero number characters" do
      password = Password.generate(numbers: 0)
      _(password).must_equal "hPQiqh*qWejG!^@"
    end
  end

  describe "special" do
    it "returns a password with an exact number of special characters" do
      password = Password.generate(special: 5)
      _(password).must_equal "*PQi07*0WejG!^@"
    end

    it "returns a password with zero special characters" do
      password = Password.generate(special: 0)
      _(password).must_equal "hPQiqh7qWejG051"
    end
  end

  describe "multiple options" do
    it "returns a password supporting all options" do
      password = Password.generate(length: 12, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      _(password).must_equal "*4P!9wgD!qO8"
    end

    it "raises an error if options total is higher than length" do
      _(proc {
        Password.generate(length: 11, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      }).must_raise Password::InvalidOptions
    end

    it "raises an error if options total is lower than length" do
      _(proc {
        Password.generate(length: 13, lowercase: 3, uppercase: 3, numbers: 3, special: 3)
      }).must_raise Password::InvalidOptions
    end
  end
end
