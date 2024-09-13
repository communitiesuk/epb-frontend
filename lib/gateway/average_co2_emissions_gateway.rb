module Gateway
  class AverageCo2EmissionsGateway < Gateway::ReportingBaseGateway
    def get_averages
      route = "/api/avg-co2-emissions"
      get(route:)
    end
  end
end
