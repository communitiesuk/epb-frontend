module ServicePerformance
  class EmptyAverageCo2EmissionsStub
    def self.body
      { data: [] }
    end

    def self.statistics
      WebMock
        .stub_request(
          :get,
          "http://test-data-warehouse-api.gov.uk/api/avg-co2-emissions",
        )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
