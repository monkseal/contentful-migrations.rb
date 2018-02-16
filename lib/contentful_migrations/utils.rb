module ContentfulMigrations
  module Utils
    def camelize(term, uppercase_first_letter = true)
      string = term.to_s
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
      else
        string = string.sub(/^((?=\b|[A-Z_])|\w)/, &:downcase)
      end
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }
      string.gsub!('/'.freeze, '::'.freeze)
      string
    end
  end
end
