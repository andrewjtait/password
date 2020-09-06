module Password
  DEFAULT_LENGTH = 15
  UPPERCASE = [*'A'..'Z'].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS = [*0..9].freeze
  SPECIAL = %w(! @ £ $ % ^ & * #).freeze

  def self.generate(length: DEFAULT_LENGTH)
    remaining_characters = length

    lowercase_count = generate_character_count(remaining_characters)
    remaining_characters -= lowercase_count

    uppercase_count = generate_character_count(remaining_characters)
    remaining_characters -= uppercase_count

    numbers_count = generate_character_count(remaining_characters)
    remaining_characters -= numbers_count

    special_count = remaining_characters

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
