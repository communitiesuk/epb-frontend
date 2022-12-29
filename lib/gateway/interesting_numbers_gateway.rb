module Gateway
  class InterestingNumbersGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def fetch
      response = @internal_api_client.get("/api/interesting-numbers")
      raise Errors::ReportIncomplete if response.status == 202

      JSON.parse(response.body, symbolize_names: true)

    end
  end
end
