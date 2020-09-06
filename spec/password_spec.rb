require "minitest/autorun"
require "password"

describe Password do
  before do
    srand(5)
  end

  describe "length" do
    it "returns a password with default of 15 characters" do
      password = Password.generate
      _(password).must_equal "m0E7hqQ5JrpIqh@"
    end

    it "returns a password with a custom length" do
      password = Password.generate(length: 30)
      _(password).must_equal "£plhrhv99bq*Q6mI2q9J4m9!enW@hq"
    end

    it "allows passwords to be longer than the default based on other options" do
      password = Password.generate(special: 30)
      _(password).must_equal "%!%!@&$%%£@!&^&*!%^!*#!!£@$£**"
    end
  end

  describe "lowercase" do
    it "returns a password with an exact number of lowercase characters" do
      password = Password.generate(lowercase: 5)
      _(password).must_equal "q0J7qeG5W17QhI1"
    end

    it "returns a password with zero lowercase characters" do
      password = Password.generate(lowercase: 0)
      _(password).must_equal "74i%07w!q5*1j@0"
    end
  end

  describe "uppercase" do
    it "returns a password with an exact number of uppercase characters" do
      password = Password.generate(uppercase: 5)
      _(password).must_equal "q0J7qeG5W17Qhi1"
    end

    it "returns a password with zero uppercase characters" do
      password = Password.generate(uppercase: 0)
      _(password).must_equal "74I%07W!Q5*1J@0"
    end
  end

  describe "numbers" do
    it "returns a password with an exact number of number characters" do
      password = Password.generate(numbers: 5)
      _(password).must_equal "q0J7qeG5W1hQhi1"
    end

    it "returns a password with zero number characters" do
      password = Password.generate(numbers: 0)
      _(password).must_equal "pWIhhq*mJqeQ!^@"
    end
  end

  describe "special" do
    it "returns a password with an exact number of special characters" do
      password = Password.generate(special: 5)
      _(password).must_equal "q!J*qeG^W@hQhi@"
    end

    it "returns a password with zero special characters" do
      password = Password.generate(special: 0)
      _(password).must_equal "pWIhhq7mJqeQ051"
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
