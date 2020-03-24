# frozen_string_literal: true

module Gateway
  class CertificatesGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search_by_postcode(postcode)
      route =
        "/api/assessments/domestic-epc/search?postcode=#{
          postcode
        }"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_id(certificate_id)
      route =
        "/api/assessments/domestic-epc/search?assessment_id=#{
          certificate_id
        }"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_street_name_and_town(street_name, town)
      route =
        "/api/assessments/domestic-epc/search?street_name=#{
          street_name
        }&town=#{town}"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end

    def fetch(assessment_id)
      route =
        "/api/assessments/domestic-epc/#{
          CGI.escape(assessment_id)
        }"

      response = @internal_api_client.get(route)

      assessment_details = JSON.parse(response.body, symbolize_names: true)

      if response.status == 200
        assessment_details[:dateOfExpiry] =
          Date.parse(assessment_details[:dateOfExpiry]).strftime('%d %B %Y')
        assessment_details[:dateOfAssessment] =
          Date.parse(assessment_details[:dateOfAssessment]).strftime('%d %B %Y')
        assessment_details[:dateRegistered] =
          Date.parse(assessment_details[:dateRegistered]).strftime('%d %B %Y')
      end

      assessment_details
    end
  end
end
