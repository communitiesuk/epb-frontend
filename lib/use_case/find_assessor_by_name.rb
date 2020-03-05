# frozen_string_literal: true

module UseCase
  class FindAssessorByName < UseCase::Base
    def execute(name)
      raise Errors::InvalidName if name == ''

      response = @gateway.search_by_name(name)

      if response.include?(:errors)
        response[:errors].each do |error|
          if error[:code] == 'Auth::Errors::TokenMissing'
            raise Errors::AuthTokenMissing
          end
        end
      end
      response
    end
  end
end
