module Password
  DEFAULT_LENGTH = 15
  UPPERCASE = [*'A'..'Z'].freeze
  LOWERCASE = [*"a".."z"].freeze
  NUMBERS = [*0..9].freeze
  SPECIAL = %w(! @ £ $ % ^ & * #).freeze

  def self.generate(length: DEFAULT_LENGTH, lowercase: nil, uppercase: nil, numbers: nil, special: nil)
    options = build_options(length, lowercase, uppercase, numbers, special)

    characters = LOWERCASE.sample(options[:lowercase]) +
                 UPPERCASE.sample(options[:uppercase]) +
                 NUMBERS.sample(options[:numbers]) +
                 SPECIAL.sample(options[:special])

    characters.shuffle.join
  end

  def self.build_options(length, lowercase, uppercase, numbers, special)
    remaining_characters = length - lowercase.to_i - uppercase.to_i - numbers.to_i - special.to_i

    raise StandardError if remaining_characters < 0

    user_defined_options = {
      lowercase: lowercase,
      uppercase: uppercase,
      numbers: numbers,
      special: special,
    }
    
    generated_options = user_defined_options.select { |k, v| v.nil? }

    generated_options.keys.each_with_index do |key, index|
      if index == generated_options.keys.length - 1
        generated_options[key] = remaining_characters
      else
        generated_options[key] = generate_character_count(remaining_characters)
      end

      remaining_characters -= generated_options[key]
    end

    raise StandardError if remaining_characters > 0

    user_defined_options.merge(generated_options)
  end

  def self.generate_character_count(remaining_characters)
    return 0 if remaining_characters == 0
    rand(1..remaining_characters)
  end
end
