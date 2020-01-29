# frozen_string_literal: true

describe RemoteUseCase::FetchAssessment do
  include RSpecUnitMixin

  let(:fetch_assessment) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context 'when an assessment doesnt exist' do
    before { FetchAssessmentNoAssessmentStub.fetch }

    it 'raises an AssessmentNotFound error' do
      expect { fetch_assessment.execute('123-456') }.to raise_error(
        RemoteUseCase::FetchAssessment::AssessmentNotFound
      )
    end
  end

  context 'when an assessment does exist' do
    before { FetchAssessmentStub.fetch('122-456') }
    it 'returns assessments' do
      result = fetch_assessment.execute('122-456')
      expect(result).to eq(
        address_summary: '2 Marsham Street, London, SW1B 2BB',
        assessment_id: '123-456',
        date_of_assessment: '02 January 2020',
        date_registered: '05 January 2020',
        dwelling_type: 'Top floor flat',
        total_floor_area: 150,
        type_of_assessment: 'RdSAP',
        current_energy_efficiency_rating: 95,
        current_energy_efficiency_band: 'a',
        potential_energy_efficiency_rating: 95,
        potential_energy_efficiency_band: 'b'
      )
    end
  end
end
