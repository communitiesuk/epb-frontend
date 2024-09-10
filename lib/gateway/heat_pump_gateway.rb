module Gateway
  class HeatPumpGateway < Gateway::ReportingBaseGateway
    def count_by_floor_area
      route = "/api/heat-pump-counts/floor-area"
      get(route:)
    end
  end
end
