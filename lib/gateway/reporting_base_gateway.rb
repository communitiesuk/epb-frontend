module Gateway
  class ReportingBaseGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

  private

    def get(route:)
      response = Helper::Response.ensure_good { @internal_api_client.get(route) }
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
