# frozen_string_literal: true

describe UseCase::FetchAssessment do
  context 'when an assessment is returned' do
    let(:assessments_gateway) { EnergyAssessmentsGatewayStub.new }
    let(:fetch_assessment) { described_class.new(assessments_gateway) }

    it 'returns empty array' do
      expect(fetch_assessment.execute('test')).to eq({})
    end
  end

  context 'when an assessment is not found' do
    let(:assessments_gateway) { EnergyAssessmentsGatewayStub.new }
    let(:fetch_assessment) { described_class.new(assessments_gateway) }

    it 'raises an error' do
      expect { fetch_assessment.execute('doesnt-exist') }.to raise_exception(
        UseCase::FetchAssessment::AssessmentNotFound
      )
    end
  end
end
