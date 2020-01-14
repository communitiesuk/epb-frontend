module UseCase
  class FetchAssessment
    class AssessmentNotFound < Exception; end

    def initialize(assessments_gateway)
      @assessments_gateway = assessments_gateway
    end

    def execute(assessment_id)
      assessment = @assessments_gateway.fetch_assessment(assessment_id)
      raise AssessmentNotFound unless assessment
      assessment
    end
  end
end
