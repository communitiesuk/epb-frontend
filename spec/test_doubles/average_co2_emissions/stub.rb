module AverageCo2Emissions
  class Stub
    def self.get_averages
      WebMock.stub_request(:get, "http://test-data-warehouse-api.gov.uk/api/avg-co2-emissions")
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
      { "data": [
        { "avgCo2Emission" => 10.0, "country" => "Northern Ireland", "yearMonth" => "2022-03" },
        { "avgCo2Emission" => 10.0, "country" => "England", "yearMonth" => "2022-05" },
      ] }.to_json
    end
  end
end
