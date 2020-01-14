# frozen_string_literal: true
require './lib/gateway/energy_assessments_gateway'

describe Gateway::EnergyAssessmentsGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end


  context 'when a certificate doesnt exist' do
    before do
      stub_request(:get, 'http://test-api.gov.uk/api/assessments/domestic-energy-performance/123-456')
          .to_return(
              status: 404
          )
    end
    it 'returns nil' do
      result = gateway.fetch_assessment('123-456')
      expect(result).to be_nil
    end
  end
end
