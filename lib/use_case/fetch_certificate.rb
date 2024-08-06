# frozen_string_literal: true

module UseCase
  class FetchCertificate < UseCase::Base
    def execute(assessment_id)
      raise Errors::AssessmentNotFound unless Helpers.rrn_format?(assessment_id.strip)

      response = @gateway.fetch(assessment_id.strip)

      raise_errors_if_exists(response) do |error|
        raise Errors::AssessmentNotFound if error[:code] == "NOT_FOUND"
        raise Errors::AssessmentGone if error[:code] == "GONE"
        raise Errors::AssessmentNotFound if error[:code] == "INVALID_QUERY"
      end

      if response.dig(:data, :recommendedImprovements)
        response[:data][:recommendedImprovements] =
          response[:data][:recommendedImprovements].sort do |x, y|
            x[:sequence] <=> y[:sequence]
          end
      end

      response
    end
  end
end
