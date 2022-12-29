module Reporting
  class InterestingNumbersStub
    def self.fetch
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/interesting-numbers",
          )
        .to_return(status: 200, body: body.to_json)
    end

    def self.fetch_202
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/interesting-numbers",
          )
        .to_return(status: 202, body: {
          "data": [],
          "meta": {}
        }.to_json)
    end


    def self.body
      { data: {name:"heat_pump_count_for_sap", data: data }}
    end

    def self.data
      [{"monthYear" => "2021-12",  "numEpcs"=> 929 },
       {"monthYear" => "2022-01",  "numEpcs"=> 963 },
       {"monthYear" => "2022-02",  "numEpcs"=> 1258 },
       {"monthYear" => "2022-03",  "numEpcs"=> 273 },
       {"monthYear" => "2022-04",  "numEpcs"=> 1 },
       {"monthYear" => "2022-05",  "numEpcs"=> 0 },
       {"monthYear" => "2022-06",  "numEpcs"=> 123 },
       {"monthYear" => "2022-07",  "numEpcs"=> 456 },
       {"monthYear" => "2022-08",  "numEpcs"=> 789 },
       {"monthYear" => "2022-09",  "numEpcs"=> 103 },
       {"monthYear" => "2022-10",  "numEpcs"=> 129 },
       {"monthYear" => "2022-12",  "numEpcs"=> 111 },
      ]
    end


  end
end
