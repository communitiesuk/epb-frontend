module HeatPumpGateway
  class Stub
    def self.count_by_floor_area
      WebMock.stub_request(:get, "http://test-data-warehouse-api.gov.uk/api/heat-pump-counts/floor-area")
        .with(
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Authorization" => "Bearer abc",
            "User-Agent" => "Faraday v2.10.1",
          },
        )
        .to_return(status: 200, body: api_data, headers: {})
    end

    def self.api_data
      { "data": [{ "totalFloorArea" => "BETWEEN 0 AND 50", "numberOfAssessments" => 1 },
                 { "totalFloorArea" => "BETWEEN 151 AND 200", "numberOfAssessments" => 1 },
                 { "totalFloorArea" => "BETWEEN 51 AND 100", "numberOfAssessments" => 1 }] }.to_json
    end
  end
end
