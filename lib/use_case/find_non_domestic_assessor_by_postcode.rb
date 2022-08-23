# frozen_string_literal: true

module UseCase
  class FindNonDomesticAssessorByPostcode < UseCase::Base
    def execute(postcode)
      Helper::PostcodeValidator.validate postcode

      response =
        @gateway.search_by_postcode(
          postcode,
          "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
        )

      raise_errors_if_exists(response) do |error|
        raise Errors::PostcodeNotRegistered if error[:code] == "NOT_FOUND"
        raise Errors::PostcodeNotValid if error[:code] == "INVALID_REQUEST"
      end

      response
    end
  end
end
