# frozen_string_literal: true

describe Gateway::EnergyAssessmentsGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context 'when an assessment doesnt exist' do
    before { FetchAssessmentNoAssessment.fetch }

    it 'returns nil' do
      result = gateway.fetch_assessment('123-456')
      expect(result).to be_nil
    end
  end

  context 'when an assessment does exist' do
    before { FetchAssessmentStub.fetch('122-456') }
    it 'returns assessments' do
      result = gateway.fetch_assessment('122-456')
      expect(result).to eq(
        {
          addressSummary: '2 Marsham Street, London, SW1B 2BB',
          assessmentId: '123-456'
        }
      )
    end
  end
end
