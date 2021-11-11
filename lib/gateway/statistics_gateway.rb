module Gateway
  class StatisticsGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def fetch
      route = "/api/statistics"
      response = @internal_api_client.get(route)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
