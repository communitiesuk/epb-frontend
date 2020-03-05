# frozen_string_literal: true

module UseCase
  class FindAssessorByPostcode < UseCase::Base
    class PostcodeNotRegistered < RuntimeError; end
    class PostcodeNotValid < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end

    def execute(postcode)
      response = @gateway.search_by_postcode(postcode)

      if response.include?(:errors)
        response[:errors].each do |error|
          raise PostcodeNotRegistered if error[:code] == 'NOT_FOUND'
          raise PostcodeNotValid if error[:code] == 'INVALID_REQUEST'
          raise AuthTokenMissing if error[:code] == 'Auth::Errors::TokenMissing'
        end
      end

      response[:results]
    end
  end
end
