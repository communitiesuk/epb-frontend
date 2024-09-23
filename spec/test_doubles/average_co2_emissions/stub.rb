module AverageCo2Emissions
  class Stub
    def self.get_averages
      WebMock.stub_request(:get, "http://epb-data-warehouse-api/api/avg-co2-emissions").to_return(status: 200, body: api_data, headers: {})
    end

    def self.api_data
      { "data": [
        { "avgCo2Emission" => 10, "country" => "Northern Ireland", "yearMonth" => "2022-03" },
        { "avgCo2Emission" => 10, "country" => "England", "yearMonth" => "2022-05" },
      ] }.to_json
    end
  end
end
