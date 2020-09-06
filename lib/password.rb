module Password
  class InvalidOptions < StandardError
    def message
      "Options are not compatible with given value of length."
    end
  end

  DEFAULT_LENGTH = 15
  UPPERCASE = [*"A".."Z"].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS = [*0..9].freeze
  SPECIAL = %w(! @ £ $ % ^ & * #).freeze

  def self.generate(length: nil, lowercase: nil, uppercase: nil, numbers: nil, special: nil)
    character_counts = populate_missing_counts({
      lowercase: lowercase,
      uppercase: uppercase,
      numbers: numbers,
      special: special,
    }, length)

    characters = generate_character_set(character_counts[:lowercase]) { UPPERCASE.sample } +
                 generate_character_set(character_counts[:uppercase]) { LOWERCASE.sample } +
                 generate_character_set(character_counts[:numbers]) { NUMBERS.sample } +
                 generate_character_set(character_counts[:special]) { SPECIAL.sample }

    characters.shuffle.join
  end

  def self.populate_missing_counts(character_counts, max_length)
    remaining_characters = calculate_remaining_characters(character_counts, max_length)
    raise InvalidOptions if remaining_characters < 0

    missing_counts = character_counts.select { |_, value| value.nil? }
    missing_counts.keys.each_with_index do |key, index|
      if index == missing_counts.keys.length - 1
        character_counts[key] = remaining_characters
      else
        character_counts[key] = generate_character_count(remaining_characters)
      end

      remaining_characters -= character_counts[key]
    end

    raise InvalidOptions if remaining_characters > 0

    character_counts
  end

  def self.calculate_remaining_characters(character_counts, max_length)
    current_total = character_counts.values.compact.inject(0, :+)

    if max_length.nil?
      max_length = (current_total > DEFAULT_LENGTH) ? current_total : DEFAULT_LENGTH
    end

    max_length - current_total
  end

  def self.generate_character_set(length)
    set = []
    while set.length < length
      set << yield
    end
    set
  end

  def self.generate_character_count(remaining_characters)
    return 0 if remaining_characters == 0
    max_total = (remaining_characters * 0.6).ceil
    rand(1..max_total)
  end
end
