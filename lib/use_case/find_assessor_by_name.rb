# frozen_string_literal: true

module UseCase
  class FindAssessorByName < UseCase::Base
    class InvalidName < StandardError; end

    def execute(name)
      raise InvalidName if name == ''

      response = @gateway.search_by_name(name)

      response[:errors].each { |error| } if response.include?(:errors)

      response
    end
  end
end
