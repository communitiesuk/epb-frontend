module Gateway
  class EnergyAssessmentsGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def fetch_assessment(assessment_id)
      route =
        URI.encode(
          "/api/assessments/domestic-energy-performance/#{assessment_id}"
        )
      response = @internal_api_client.get(route)
      if response.status == 404
        nil
      else
        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
