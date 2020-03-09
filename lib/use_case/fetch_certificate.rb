# frozen_string_literal: true

module UseCase
  class FetchCertificate < UseCase::Base
    def execute(assessment_id)
      response = @gateway.fetch(assessment_id)

      raise_errors_if_exists(response) do |error_code|
        raise Errors::AssessmentNotFound if error_code == 'NOT_FOUND'
      end

      response
    end
  end
end
