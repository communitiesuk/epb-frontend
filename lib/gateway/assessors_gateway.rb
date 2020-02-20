# frozen_string_literal: true

module Gateway
  class AssessorsGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search_by_postcode(postcode)
      route = URI.encode("/api/assessors?postcode=#{postcode}")
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end

    def search_by_name(name)
      route = URI.encode("/api/assessors?name=#{name}")
      response = @internal_api_client.get(route)

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
