module HeatPumpGateway
  class Stub
    def self.count_by_floor_area(status: 200)
      WebMock.stub_request(:get, "http://epb-data-warehouse-api/api/heat-pump-counts/floor-area").to_return(status:, body: api_data, headers: {})
    end

    def self.api_data
      { "data": [{ "totalFloorArea" => "BETWEEN 0 AND 50", "numberOfAssessments" => 1 },
                 { "totalFloorArea" => "BETWEEN 151 AND 200", "numberOfAssessments" => 1 },
                 { "totalFloorArea" => "BETWEEN 51 AND 100", "numberOfAssessments" => 1 }] }.to_json
    end
  end
end
