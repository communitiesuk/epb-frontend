module ServicePerformance
  class AverageCo2EmissionsStub
    def self.body
      { data: assessments_stats }
    end

    def self.statistics
      WebMock
        .stub_request(
          :get,
          "http://test-data-warehouse-api.gov.uk/api/avg-co2-emissions",
        )
        .to_return(status: 200, body: body.to_json)
    end

    private_class_method def self.assessments_stats
      [{
        "average_co2": 15.73676647,
        "yearMonth": "2021-09",
        "country": "England",
      },
       {
         "average_co2": 34.345225235,
         "yearMonth": "2021-09",
         "country": "Northern Ireland",
       },
       {
         "average_co2": 23.2674765367,
         "yearMonth": "2021-09",
         "country": "Wales",
       },
       {
         "average_co2": 21.127637883376,
         "yearMonth": "2021-09",
         "country": "Other",
       }]
    end
  end
end
