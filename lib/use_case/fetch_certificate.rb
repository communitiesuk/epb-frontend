# frozen_string_literal: true

module UseCase
  class FetchCertificate < UseCase::Base
    def execute(assessment_id)
      response = @gateway.fetch(assessment_id)

      raise_errors_if_exists(response) do |error_code|
        raise Errors::AssessmentNotFound if error_code == "NOT_FOUND"
      end

      if response[:data][:recommendedImprovements]
        response[:data][:recommendedImprovements] =
          response[:data][:recommendedImprovements].sort do |x, y|
            x[:sequence] <=> y[:sequence]
          end
      end

      response
    end
  end
end
