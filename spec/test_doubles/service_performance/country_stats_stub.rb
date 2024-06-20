module ServicePerformance
  class CountryStatsStub
    def self.body
      { data: { assessments: assessments_stats } }
    end

    def self.statistics
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/statistics",
        )
        .to_return(status: 200, body: body.to_json)
    end

    private_class_method def self.assessments_stats
      { all: ServicePerformance::Stub.body[:data][:assessments],
        england: [
          {
            "numAssessments": 121_499,
            "assessmentType": "RdSAP",
            "ratingAverage": 61.7122807017544,
            "month": "2021-09",
            "country": "England",
          },
          {
            "numAssessments": 112_499,
            "assessmentType": "SAP",
            "ratingAverage": 61.7122807017544,
            "month": "2021-09",
            "country": "England",
          },
          {
            "numAssessments": 92_124,
            "assessmentType": "CEPC",
            "ratingAverage": 47.7122807017544,
            "month": "2021-09",
            "country": "England",
          },
          {
            "numAssessments": 367,
            "assessmentType": "DEC",
            "ratingAverage": 0.0,
            "month": "2020-09",
            "country": "England",
          },
          {
            "numAssessments": 36,
            "assessmentType": "DEC-RR",
            "ratingAverage": 0.0,
            "month": "2020-09",
            "country": "England",
          },
          {
            "numAssessments": 32,
            "assessmentType": "AC-CERT",
            "ratingAverage": 0.0,
            "month": "2020-09",
            "country": "England",
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
        ],
        wales: [
          {
            "numAssessments": 5779,
            "assessmentType": "RdSAP",
            "ratingAverage": 59.1234156,
            "month": "2021-09",
            "country": "Wales",
          },
          {
            "numAssessments": 4892,
            "assessmentType": "SAP",
            "ratingAverage": 61.7122807017544,
            "month": "2021-09",
            "country": "Wales",
          },
          {
            "numAssessments": 874,
            "assessmentType": "CEPC",
            "ratingAverage": 47.7122807017544,
            "month": "2021-09",
            "country": "Wales",
          },

        ],
        other: [
          {
            "numAssessments": 5779,
            "assessmentType": "RdSAP",
            "ratingAverage": 59.1234156,
            "month": "2021-09",
            "country": "Other",
          },
          {
            "numAssessments": 4892,
            "assessmentType": "SAP",
            "ratingAverage": 61.7122807017544,
            "month": "2021-09",
            "country": "Other",
          },

          {
            "numAssessments": 26,
            "assessmentType": "CEPC",
            "ratingAverage": 61.7122807017544,
            "month": "2021-09",
            "country": "Other",
          },

        ] }
    end
  end
end
