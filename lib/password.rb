module Password
  class InvalidOptionsError < StandardError
  end

  DEFAULT_LENGTH = 15

  UPPERCASE = [*"A".."Z"].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS   = [*0..9].freeze
  SPECIAL   = %w(@ % ! ? * ^ &).freeze

  class << self
    attr_reader :character_counts, :max_length

    def generate(length: nil, lowercase: nil, uppercase: nil, numbers: nil, special: nil)
      @max_length = length
      @character_counts = {
        lowercase: lowercase,
        uppercase: uppercase,
        numbers: numbers,
        special: special,
      }

      validate_length
      validate_character_counts

      generate_characters.shuffle.join
    end

    private

    def validate_length
      return if max_length.nil?
      raise InvalidOptionsError if !max_length.is_a?(Integer) || max_length < 1
    end

    # Populate any nil values within the character_counts hash and validate them.
    def validate_character_counts
      # Raise an error if a value is not valid:
      character_counts.values.compact.each do |count|
        raise InvalidOptionsError if !count.is_a?(Integer) || count < 0
      end

      # Populate any missing values:
      missing_counts = character_counts.select { |_, value| value.nil? }
      missing_counts.keys.each_with_index do |key, index|
        last_item = (index == missing_counts.keys.length - 1)
        character_counts[key] = last_item ? remaining_character_count : random_character_count
      end

      # Raise an error if the total options are less than or more than the defined length:
      raise InvalidOptionsError if remaining_character_count != 0
    end

    # Remaining characters is based on the sum of current character counts subtracted
    # from the max length.
    def remaining_character_count
      current_total = character_counts.values.compact.inject(0, :+)

      # Max length is based on:
      #  1. The user defined length argument.
      #  2. The total of user defined options (if higher than DEFAULT_LENGTH or user
      #     has defined all possible options).
      #  3. The DEFAULT_LENGTH.
      if max_length.nil?
        all_options_defined = character_counts.values.compact.length == 4

        if all_options_defined || (current_total > DEFAULT_LENGTH)
          @max_length = current_total
        else
          @max_length = DEFAULT_LENGTH
        end
      end

      max_length - current_total
    end

    # Build and join sets of characters for each character type.
    def generate_characters
      generate_character_set(character_counts[:lowercase]) { LOWERCASE.sample } +
      generate_character_set(character_counts[:uppercase]) { UPPERCASE.sample } +
      generate_character_set(character_counts[:numbers]) { NUMBERS.sample } +
      generate_character_set(character_counts[:special]) { SPECIAL.sample }
    end

    # Build an array of characters for the given length.
    def generate_character_set(length)
      set = []
      while set.length < length
        set << yield
      end
      set
    end

    # Return a random number for how many characters to use for the current
    # character type based on the remaining characters available.
    def random_character_count
      # Reduce the maximum number a bit so that we have a better chance
      # of a good mixture of character types:
      maximum = (remaining_character_count * 0.6).ceil
      rand(0..maximum)
    end
  end
end
