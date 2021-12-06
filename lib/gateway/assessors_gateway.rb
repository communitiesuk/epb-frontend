# frozen_string_literal: true

module Gateway
  class AssessorsGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search_by_postcode(
      postcode,
      qualification
    )
      route =
        "/api/assessors?postcode=#{CGI.escape(postcode)}&qualification=#{
          CGI.escape(qualification)
        }"
      response =
        Helper::Response.ensure_good { @internal_api_client.get(route) }

      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_name(name, qualification_type = "")
      route = "/api/assessors?name=#{CGI.escape(name)}&qualificationType=#{
        CGI.escape(qualification_type)}"
      response =
        Helper::Response.ensure_good { @internal_api_client.get(route) }

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
