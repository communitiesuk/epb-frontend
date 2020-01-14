module UseCase
  class FetchAssessment

    class AssessmentNotFound < Exception
    end

    def initialize(assessments_gateway)
      @assessments_gateway = assessments_gateway
    end

    def execute(assessment_id)
      assessment = @assessments_gateway.fetch(assessment_id)
      unless assessment
        raise AssessmentNotFound
      end
      assessment
    end
  end
end

