# frozen_string_literal: true

describe RemoteUseCase::FetchAssessment do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context 'when an assessment doesnt exist' do
    before { FetchAssessmentNoAssessmentStub.fetch }

    it 'raises an AssessmentNotFound error' do
      expect { gateway.execute('123-456') }.to raise_error(
        RemoteUseCase::FetchAssessment::AssessmentNotFound
      )
    end
  end

  context 'when an assessment does exist' do
    before { FetchAssessmentStub.fetch('122-456') }
    it 'returns assessments' do
      result = gateway.execute('122-456')
      expect(result).to eq(
        {
          address_summary: '2 Marsham Street, London, SW1B 2BB',
          assessment_id: '123-456',
          date_of_assessment: '02 January 2020',
          date_registered: '05 January 2020',
          dwelling_type: 'Top floor flat',
          total_floor_area: 150,
          type_of_assessment: 'RdSAP'
        }
      )
    end
  end
end
