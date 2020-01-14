require './lib/use_case/fetch_assessment'
describe UseCase::FetchAssessment do
  class GatewayStub
    def fetch_assessment(certificate_id)
      certificate_id == 'doesnt-exist' ? nil : {}
    end
  end

  context 'when an assessment is returned' do
    let(:assessments_gateway) { GatewayStub.new }
    let(:fetch_assessment) { described_class.new(assessments_gateway) }

    it 'returns empty array' do
      expect(fetch_assessment.execute('test')).to eq({})
    end
  end

  context 'when an assessment is not found' do
    let(:assessments_gateway) { GatewayStub.new }
    let(:fetch_assessment) { described_class.new(assessments_gateway) }

    it 'raises an error' do
      expect { fetch_assessment.execute('doesnt-exist') }.to raise_exception(
        UseCase::FetchAssessment::AssessmentNotFound
      )
    end
  end
end
