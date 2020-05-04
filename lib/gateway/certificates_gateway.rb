# frozen_string_literal: true

module Gateway
  class CertificatesGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search_by_postcode(postcode)
      route =
        "/api/assessments/domestic-epc/search?postcode=#{CGI.escape(postcode)}"
      response = @internal_api_client.get(route)

      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_id(certificate_id)
      route =
        "/api/assessments/domestic-epc/search?assessment_id=#{CGI.escape(certificate_id)}"
      response = @internal_api_client.get(route)

      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_street_name_and_town(street_name, town)
      route =
        "/api/assessments/domestic-epc/search?street_name=#{CGI.escape(street_name)}&town=#{CGI.escape(town)}"
      response = @internal_api_client.get(route)

      JSON.parse(response.body, symbolize_names: true)
    end

    def fetch(assessment_id)
      route = "/api/assessments/domestic-epc/#{CGI.escape(assessment_id)}"
      response = @internal_api_client.get(route)

      assessment_details = JSON.parse(response.body, symbolize_names: true)

      if response.status == 200
        assessment_details[:data][:dateOfExpiry] =
          Date.parse(assessment_details[:data][:dateOfExpiry]).strftime(
            "%d %B %Y",
          )
        assessment_details[:data][:dateOfAssessment] =
          Date.parse(assessment_details[:data][:dateOfAssessment]).strftime(
            "%d %B %Y",
          )
        assessment_details[:data][:dateRegistered] =
          Date.parse(assessment_details[:data][:dateRegistered]).strftime(
            "%d %B %Y",
          )
      end

      assessment_details
    end
  end
end
