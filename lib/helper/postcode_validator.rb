module Helper
  class PostcodeValidator
    def self.validate(postcode)
      stripped = postcode.strip
      # regex pattern for nan alpha numeric chars (except white space)
      alpha_numeric_pattern = /^[0-9A-Za-z\s:]+$/
      raise Errors::PostcodeIncomplete if stripped.empty? || stripped.match?(alpha_numeric_pattern) && stripped.length < 5
      raise Errors::PostcodeWrongFormat if stripped.match?(alpha_numeric_pattern) && stripped.length > 8

      unless Regexp
               .new("^[a-zA-Z0-9_ ]{5,10}$", Regexp::IGNORECASE)
               .match(stripped)
        raise Errors::PostcodeNotValid
      end

      true
    end
  end
end
