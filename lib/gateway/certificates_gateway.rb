# frozen_string_literal: true

module Gateway
  class CertificatesGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search_by_postcode(postcode, types)
      route = "/api/assessments/search?postcode=#{CGI.escape(postcode)}"

      types.each { |type| route += "&assessment_type[]=#{type}" }

      response = ensure_good { @internal_api_client.get(route) }

      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_id(certificate_id)
      route =
        "/api/assessments/search?assessment_id=#{CGI.escape(certificate_id)}"
      response = ensure_good { @internal_api_client.get(route) }

      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_street_name_and_town(street_name, town, assessment_types)
      route =
        "/api/assessments/search?street_name=#{CGI.escape(street_name)}&town=#{
          CGI.escape(town)
        }"
      assessment_types.each { |type| route += "&assessment_type[]=#{type}" }

      response = ensure_good { @internal_api_client.get(route) }

      JSON.parse(response.body, symbolize_names: true)
    end

    def fetch_dec_summary(certificate_id)
      route = "/api/dec_summary/#{CGI.escape(certificate_id)}"

      response = ensure_good { @internal_api_client.get(route) }

      JSON.parse(response.body, symbolize_names: true)
    end

  private

    def ensure_good(&block)
      Helper::Response.ensure_good(&block)
    end
  end
end
