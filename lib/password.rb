module Password
  class InvalidOptionsError < StandardError
  end

  DEFAULT_LENGTH = 15

  UPPERCASE = [*"A".."Z"].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS   = [*0..9].freeze
  SPECIAL   = %w(@ % ! ? * ^ &).freeze

  class << self
    def generate(length: nil, lowercase: nil, uppercase: nil, numbers: nil, special: nil)
      max_length = length
      character_counts = {
        lowercase: lowercase,
        uppercase: uppercase,
        numbers: numbers,
        special: special,
      }

      validate_custom_options(character_counts, max_length)

      max_length ||= set_max_length(character_counts)
      character_counts = set_character_counts(character_counts, max_length)

      generate_characters(character_counts).shuffle.join
    end

    private

    def validate_custom_options(character_counts, max_length)
      unless max_length.nil?
        raise InvalidOptionsError if !max_length.is_a?(Integer) || max_length < 1
      end

      character_counts.values.compact.each do |count|
        raise InvalidOptionsError if !count.is_a?(Integer) || count < 0
      end
    end

    # Max length is based on:
    #  1. The user defined length argument.
    #  2. The total of user defined options (if higher than DEFAULT_LENGTH or user
    #     has defined all possible options).
    #  3. The DEFAULT_LENGTH.
    def set_max_length(character_counts)
      current_total = current_character_count(character_counts)
      all_options_defined = !character_counts.values.any?(&:nil?)

      if all_options_defined || (current_total > DEFAULT_LENGTH)
        current_total
      else
        DEFAULT_LENGTH
      end
    end

    def set_character_counts(character_counts, max_length)
      raise InvalidOptionsError if remaining_character_count(character_counts, max_length) < 0

      # Populate any missing values:
      missing_counts = character_counts.select { |_, value| value.nil? }
      missing_counts.keys.each_with_index do |key, index|
        last_item = (index == missing_counts.keys.length - 1)
        if last_item
          character_counts[key] = remaining_character_count(character_counts, max_length)
        else
          character_counts[key] = random_character_count(character_counts, max_length)
        end
      end

      raise InvalidOptionsError if remaining_character_count(character_counts, max_length) != 0

      character_counts
    end

    def remaining_character_count(character_counts, max_length)
      max_length - current_character_count(character_counts)
    end

    def current_character_count(character_counts)
      character_counts.values.compact.inject(0, :+)
    end

    def generate_characters(character_counts)
      generate_character_set(character_counts[:lowercase]) { LOWERCASE.sample } +
      generate_character_set(character_counts[:uppercase]) { UPPERCASE.sample } +
      generate_character_set(character_counts[:numbers]) { NUMBERS.sample } +
      generate_character_set(character_counts[:special]) { SPECIAL.sample }
    end

    def generate_character_set(length)
      set = []
      while set.length < length
        set << yield
      end
      set
    end

    def random_character_count(character_counts, max_length)
      # Reduce the maximum number a bit so that we have a better chance
      # of a good mixture of character types:
      maximum = (remaining_character_count(character_counts, max_length) * 0.6).ceil
      rand(0..maximum)
    end
  end
end
