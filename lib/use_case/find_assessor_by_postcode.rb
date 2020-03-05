# frozen_string_literal: true

module UseCase
  class FindAssessorByPostcode < UseCase::Base
    def execute(postcode)
      response = @gateway.search_by_postcode(postcode)

      if response.include?(:errors)
        response[:errors].each do |error|
          raise Errors::PostcodeNotRegistered if error[:code] == 'NOT_FOUND'
          raise Errors::PostcodeNotValid if error[:code] == 'INVALID_REQUEST'
          if error[:code] == 'Auth::Errors::TokenMissing'
            raise Errors::AuthTokenMissing
          end
        end
      end

      response[:results]
    end
  end
end
