module ServicePerformance
  class Stub
    def self.body
      { data: [
        {
          "numAssessments": 144_533,
          "assessmentType": "CEPC",
          "ratingAverage": 71.85,
          "month": "2020-11",
        },
        {
          "numAssessments": 121_499,
          "assessmentType": "RdSAP",
          "ratingAverage": 61.7122807017544,
          "month": "2021-09",
        },
        {
          "numAssessments": 6742,
          "assessmentType": "DEC-RR",
          "ratingAverage": 0.0,
          "month": "2020-10",
        },
        {
          "numAssessments": 2837,
          "assessmentType": "CEPC",
          "ratingAverage": 66.24,
          "month": "2021-11",
        },
        {
          "numAssessments": 1368,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "month": "2021-03",
        },
        {
          "numAssessments": 6514,
          "assessmentType": "CEPC",
          "ratingAverage": 72.843537414966,
          "month": "2021-02",
        },
        {
          "numAssessments": 20_444,
          "assessmentType": "SAP",
          "ratingAverage": 78.3304347826087,
          "month": "2021-07",
        },
        {
          "numAssessments": 626,
          "assessmentType": "DEC-RR",
          "ratingAverage": 0.0,
          "month": "2021-07",
        },
        {
          "numAssessments": 1653,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "month": "2021-06",
        },
        {
          "numAssessments": 23_866,
          "assessmentType": "SAP",
          "ratingAverage": 76.9909090909091,
          "month": "2021-01",
        },
        {
          "numAssessments": 4874,
          "assessmentType": "DEC",
          "ratingAverage": 0.0,
          "month": "2020012",
        },
        {
          "numAssessments": 8422,
          "assessmentType": "SAP",
          "ratingAverage": 79.6190476190476,
          "month": "2021-12",
        },
        {
          "numAssessments": 261_069,
          "assessmentType": "SAP",
          "ratingAverage": 77.2258064516129,
          "month": "2020-10",
        },
        {
          "numAssessments": 2272,
          "assessmentType": "DEC",
          "ratingAverage": 0.0,
          "month": "2021-04",
        },
        {
          "numAssessments": 918,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "month": "2021-09",
        },
        {
          "numAssessments": 133_760,
          "assessmentType": "RdSAP",
          "ratingAverage": 60.3431734317343,
          "month": "2020-12",
        },
        {
          "numAssessments": 574,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "month": "2021-11",
        },
      ] }
    end

    def self.statistics
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/statistics",
        )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
