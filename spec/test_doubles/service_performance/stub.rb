module ServicePerformance
  class Stub
    def self.body
      { data: [
        {
          "numAssessments": 144_533,
          "assessmentType": "CEPC",
          "ratingAverage": 71.85,
          "monthYear": "11-2020",
        },
        {
          "numAssessments": 121_499,
          "assessmentType": "RdSAP",
          "ratingAverage": 61.7122807017544,
          "monthYear": "09-2021",
        },
        {
          "numAssessments": 6742,
          "assessmentType": "DEC-RR",
          "ratingAverage": 0.0,
          "monthYear": "10-2020",
        },
        {
          "numAssessments": 2837,
          "assessmentType": "CEPC",
          "ratingAverage": 66.24,
          "monthYear": "11-2021",
        },
        {
          "numAssessments": 1368,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "monthYear": "03-2021",
        },
        {
          "numAssessments": 6514,
          "assessmentType": "CEPC",
          "ratingAverage": 72.843537414966,
          "monthYear": "02-2021",
        },
        {
          "numAssessments": 20_444,
          "assessmentType": "SAP",
          "ratingAverage": 78.3304347826087,
          "monthYear": "07-2021",
        },
        {
          "numAssessments": 626,
          "assessmentType": "DEC-RR",
          "ratingAverage": 0.0,
          "monthYear": "07-2021",
        },
        {
          "numAssessments": 1653,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "monthYear": "06-2021",
        },
        {
          "numAssessments": 23_866,
          "assessmentType": "SAP",
          "ratingAverage": 76.9909090909091,
          "monthYear": "01-2021",
        },
        {
          "numAssessments": 4874,
          "assessmentType": "DEC",
          "ratingAverage": 0.0,
          "monthYear": "12-2020",
        },
        {
          "numAssessments": 8422,
          "assessmentType": "SAP",
          "ratingAverage": 79.6190476190476,
          "monthYear": "11-2021",
        },
        {
          "numAssessments": 261_069,
          "assessmentType": "SAP",
          "ratingAverage": 77.2258064516129,
          "monthYear": "10-2020",
        },
        {
          "numAssessments": 2272,
          "assessmentType": "DEC",
          "ratingAverage": 0.0,
          "monthYear": "04-2021",
        },
        {
          "numAssessments": 918,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "monthYear": "09-2021",
        },
        {
          "numAssessments": 133_760,
          "assessmentType": "RdSAP",
          "ratingAverage": 60.3431734317343,
          "monthYear": "12-2020",
        },
        {
          "numAssessments": 574,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "monthYear": "11-2021",
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
