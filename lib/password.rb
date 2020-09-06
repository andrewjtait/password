module Password
  DEFAULT_LENGTH = 15
  UPPERCASE = [*'A'..'Z'].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS = [*0..9].freeze
  SPECIAL = %w(! @ £ $ % ^ & * #).freeze

  def self.generate(length: DEFAULT_LENGTH, lowercase: nil, uppercase: nil, numbers: nil, special: nil)
    remaining_characters = length - lowercase.to_i - uppercase.to_i - numbers.to_i - special.to_i

    if lowercase
      lowercase_count = lowercase
    else
      lowercase_count = generate_character_count(remaining_characters)
      remaining_characters -= lowercase_count
    end

    if uppercase
      uppercase_count = uppercase
    else
      uppercase_count = generate_character_count(remaining_characters)
      remaining_characters -= uppercase_count
    end

    if numbers
      numbers_count = numbers
    else
      numbers_count = generate_character_count(remaining_characters)
      remaining_characters -= numbers_count
    end

    special_count = special || remaining_characters

    characters = LOWERCASE.sample(lowercase_count) +
                 UPPERCASE.sample(uppercase_count) +
                 NUMBERS.sample(numbers_count) +
                 SPECIAL.sample(special_count)

    characters.shuffle.join
  end

  def self.generate_character_count(remaining_characters)
    return 0 if remaining_characters == 0
    rand(1..remaining_characters)
  end
end
