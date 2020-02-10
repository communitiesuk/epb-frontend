# frozen_string_literal: true

module Gateway
  class CertificatesGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search(postcode)
      route = URI.encode("/api/assessments/domestic-energy-performance/search/#{postcode}")
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
