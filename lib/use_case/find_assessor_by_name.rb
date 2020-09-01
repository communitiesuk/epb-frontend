# frozen_string_literal: true

module UseCase
  class FindAssessorByName < UseCase::Base
    def execute(name)
      raise Errors::InvalidName if name == "" || name.split.size < 2

      response = @gateway.search_by_name(name)

      raise_errors_if_exists(response)

      response
    end
  end
end
