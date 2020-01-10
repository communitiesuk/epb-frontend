module Gateway
  class AssessorsGateway

    def initialize(api_client)
      @internal_api_client = api_client
    end

    def search(postcode)
      @route = URI.encode("/api/assessors/search/#{postcode}")

      response = @internal_api_client.get(@route)

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
