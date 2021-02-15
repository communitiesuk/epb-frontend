# frozen_string_literal: true

module UseCase
  class FindAssessorByPostcode < UseCase::Base
    def execute(postcode)
      response = @gateway.search_by_postcode(postcode)

      raise_errors_if_exists(response) do |error|
        raise Errors::PostcodeNotRegistered if error[:code] == "NOT_FOUND"
        raise Errors::PostcodeNotValid if error[:code] == "INVALID_REQUEST"
      end

      response
    end
  end
end
