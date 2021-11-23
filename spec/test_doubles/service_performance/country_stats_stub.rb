module ServicePerformance
  class CountryStatsStub
    def self.body
      { data:
         { all: ServicePerformance::Stub.body[:data],
           englandWales: [{
             "numAssessments": 121_499,
             "assessmentType": "RdSAP",
             "ratingAverage": 61.7122807017544,
             "month": "09-2021",
           },
                          {
                            "numAssessments": 112_499,
                            "assessmentType": "SAP",
                            "ratingAverage": 61.7122807017544,
                            "month": "09-2021",
                          },
                          {
                            "numAssessments": 92_124,
                            "assessmentType": "CEPC",
                            "ratingAverage": 47.7122807017544,
                            "month": "09-2021",
                          }],
           northernIreland: [{
             "numAssessments": 5779,
             "assessmentType": "RdSAP",
             "ratingAverage": 59.1234156,
             "month": "09-2021",
           },
                             {
                               "numAssessments": 4892,
                               "assessmentType": "SAP",
                               "ratingAverage": 61.7122807017544,
                               "month": "09-2021",
                             },
                             {
                               "numAssessments": 874,
                               "assessmentType": "CEPC",
                               "ratingAverage": 47.7122807017544,
                               "month": "09-2021",
                             }] } }
    end

    def self.statistics
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/statistics/new",
        )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
