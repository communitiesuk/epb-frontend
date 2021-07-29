# frozen_string_literal: true

module UseCase
  class FindAssessorByName < UseCase::Base
    def execute(name, qualification_type)
      raise Errors::InvalidName if name == "" || name.split.size < 2

      response = @gateway.search_by_name(name, qualification_type)

      raise_errors_if_exists(response) do |error|
        raise Errors::InvalidName if error[:code] == "INVALID_REQUEST"
      end

      response
    end
  end
end
