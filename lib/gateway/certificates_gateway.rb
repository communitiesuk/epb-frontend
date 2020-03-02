# frozen_string_literal: true

module Gateway
  class CertificatesGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search_by_postcode(postcode)
      route =
        "/api/assessments/domestic-energy-performance/search?postcode=#{
          postcode
        }"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_id(certificate_id)
      route =
        "/api/assessments/domestic-energy-performance/search?assessment_id=#{
          certificate_id
        }"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_street_name_and_town(street_name, town)
      route =
        "/api/assessments/domestic-energy-performance/search?street_name=#{
          street_name
        }&town=#{town}"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
