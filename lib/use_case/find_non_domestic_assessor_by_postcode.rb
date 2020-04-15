# frozen_string_literal: true

module UseCase
  class FindNonDomesticAssessorByPostcode < UseCase::Base
    def execute(postcode)
      response =
        @gateway.search_by_postcode(
          postcode,
          'nonDomesticSp3,nonDomesticCc4,nonDomesticDec'
        )

      raise_errors_if_exists(response) do |error_code|
        raise Errors::PostcodeNotRegistered if error_code == 'NOT_FOUND'
        raise Errors::PostcodeNotValid if error_code == 'INVALID_REQUEST'
      end

      response
    end
  end
end
