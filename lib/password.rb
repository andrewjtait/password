module Password
  class InvalidOptions < StandardError
    def message
      "Options are not compatible for the current value of length."
    end
  end

  DEFAULT_LENGTH = 15

  # Character type sets:
  UPPERCASE = [*"A".."Z"].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS = [*0..9].freeze
  SPECIAL = %w(@ % ! ? * ^ &).freeze

  def self.generate(length: nil, lowercase: nil, uppercase: nil, numbers: nil, special: nil)
    character_counts = populate_missing_counts({
      lowercase: lowercase,
      uppercase: uppercase,
      numbers: numbers,
      special: special,
    }, length)

    characters = generate_character_set(character_counts[:lowercase]) { LOWERCASE.sample } +
                 generate_character_set(character_counts[:uppercase]) { UPPERCASE.sample } +
                 generate_character_set(character_counts[:numbers]) { NUMBERS.sample } +
                 generate_character_set(character_counts[:special]) { SPECIAL.sample }

    characters.shuffle.join
  end

  # Fill in any nil values within the character_counts hash.
  def self.populate_missing_counts(character_counts, max_length)
    remaining_characters = calculate_remaining_characters(character_counts, max_length)

    # Raise an error if the total options are more than the defined length:
    raise InvalidOptions if remaining_characters < 0

    missing_counts = character_counts.select { |_, value| value.nil? }
    missing_counts.keys.each_with_index do |key, index|
      if index == missing_counts.keys.length - 1
        # Use whatever characters are left if it is the last missing set:
        character_counts[key] = remaining_characters
      else
        character_counts[key] = random_character_count(remaining_characters)
      end

      remaining_characters -= character_counts[key]
    end

    # Raise an error if the total options are less than the defined length:
    raise InvalidOptions if remaining_characters > 0

    character_counts
  end

  # Remaining characters is based on the total of user defined options subtracted
  # from the max length.
  #
  # Max length is based on:
  #  1. The user defined length argument.
  #  2. The total of user defined options (if higher than DEFAULT_LENGTH).
  #  3. The DEFAULT_LENGTH.
  def self.calculate_remaining_characters(character_counts, max_length)
    current_total = character_counts.values.compact.inject(0, :+)

    if max_length.nil?
      max_length = (current_total > DEFAULT_LENGTH) ? current_total : DEFAULT_LENGTH
    end

    max_length - current_total
  end

  # Build an array of characters for the given length.
  def self.generate_character_set(length)
    set = []
    while set.length < length
      set << yield
    end
    set
  end

  # Return a random number for how many characters to use for the current
  # character type based on the remaining characters available.
  def self.random_character_count(remaining_characters)
    return 0 if remaining_characters == 0

    # Use a buffer on the remaining characters to ensure we get a good
    # mixture of character types:
    maximum = (remaining_characters * 0.6).ceil

    rand(1..maximum)
  end
end
