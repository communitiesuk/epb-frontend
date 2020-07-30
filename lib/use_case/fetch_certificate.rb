# frozen_string_literal: true

module UseCase
  class FetchCertificate < UseCase::Base
    def execute(assessment_id)
      # Attempt to use the assessment summary endpoint first
      assessment_summmary =
        Gateway::AssessmentSummaryGateway.new.fetch(assessment_id)

      if assessment_summmary
        assessment_summmary
      else
        response = @gateway.fetch(assessment_id)

        raise_errors_if_exists(response) do |error_code|
          raise Errors::AssessmentNotFound if error_code == "NOT_FOUND"
          raise Errors::AssessmentNotFound if error_code == "GONE"
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
end
