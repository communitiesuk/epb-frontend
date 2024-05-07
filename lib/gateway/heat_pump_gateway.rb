module Gateway
  class HeatPumpGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def count_by_floor_area
      route = "/api/heat-pump-counts/floor-area"

      response = @internal_api_client.get(route)

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
