class EnergyAssessmentsGatewayStub
  def fetch_assessment(assessment_id)
    assessment_id == 'doesnt-exist' ? nil : {}
  end
end
