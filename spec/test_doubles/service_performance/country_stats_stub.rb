module ServicePerformance
  class CountryStatsStub
    def self.body
      { data:
         { all: ServicePerformance::Stub.body[:data],
           englandWales: [
             {
               "numAssessments": 121_499,
               "assessmentType": "RdSAP",
               "ratingAverage": 61.7122807017544,
               "month": "2021-09",
               "country": "England & Wales",
             },
             {
               "numAssessments": 112_499,
               "assessmentType": "SAP",
               "ratingAverage": 61.7122807017544,
               "month": "2021-09",
               "country": "England & Wales",
             },
             {
               "numAssessments": 92_124,
               "assessmentType": "CEPC",
               "ratingAverage": 47.7122807017544,
               "month": "2021-09",
               "country": "England & Wales",
             },
             {
               "numAssessments": 367,
               "assessmentType": "DEC",
               "ratingAverage": 0.0,
               "month": "2020-09",
               "country": "England & Wales",
             },
             {
               "numAssessments": 36,
               "assessmentType": "DEC-RR",
               "ratingAverage": 0.0,
               "month": "2020-09",
               "country": "England & Wales",
             },
             {
               "numAssessments": 32,
               "assessmentType": "AC-CERT",
               "ratingAverage": 0.0,
               "month": "2020-09",
               "country": "England & Wales",
             },
           ],
           northernIreland: [
             {
               "numAssessments": 5779,
               "assessmentType": "RdSAP",
               "ratingAverage": 59.1234156,
               "month": "2021-09",
               "country": "Northern Ireland",
             },
             {
               "numAssessments": 4892,
               "assessmentType": "SAP",
               "ratingAverage": 61.7122807017544,
               "month": "2021-09",
               "country": "Northern Ireland",
             },
             {
               "numAssessments": 874,
               "assessmentType": "CEPC",
               "ratingAverage": 47.7122807017544,
               "month": "2021-09",
               "country": "Northern Ireland",
             },
             {
               "numAssessments": 67,
               "assessmentType": "DEC",
               "ratingAverage": 0.0,
               "month": "2020-09",
               "country": "Northern Ireland",
             },
             {
               "numAssessments": 6,
               "assessmentType": "DEC-RR",
               "ratingAverage": 0.0,
               "month": "2020-09",
               "country": "Northern Ireland",
             },
             {
               "numAssessments": 2,
               "assessmentType": "AC-CERT",
               "ratingAverage": 0.0,
               "month": "2020-09",
               "country": "Northern Ireland",
             },
           ] } }
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
