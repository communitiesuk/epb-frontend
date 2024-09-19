module ServicePerformance
  class AverageCo2EmissionsStub
    def self.body
      { data: assessments_stats }
    end

    def self.statistics
      WebMock
        .stub_request(
          :get,
          "http://epb-data-warehouse-api/api/avg-co2-emissions",
        )
        .to_return(status: 200, body: body.to_json)
    end

    private_class_method def self.assessments_stats
      { all: [{ "avgCo2Emission": 16.23655,
                "yearMonth": "2021-09",
                "assessmentType": "SAP" },
              { "avgCo2Emission": 34.345225235,
                "yearMonth": "2022-03",
                "assessmentType": "SAP" },
              { "avgCo2Emission": 10.883267,
                "yearMonth": "2021-09",
                "assessmentType": "RdSAP" }],
        northernIreland: [{ "avgCo2Emission": 34.345225235,
                            "country": "Northern Ireland",
                            "yearMonth": "2022-03",
                            "assessmentType": "SAP" }],
        england: [{ "avgCo2Emission": 15.7367,
                    "country": "England",
                    "yearMonth": "2021-09",
                    "assessmentType": "SAP" },
                  { "avgCo2Emission": 10.883267,
                    "country": "England",
                    "yearMonth": "2021-09",
                    "assessmentType": "RdSAP" }],
        wales: [{ "avgCo2Emission": 16.7364,
                  "country": "Wales",
                  "yearMonth": "2022-05",
                  "assessmentType": "SAP" }],
        other: [{ "avgCo2Emission": 10,
                  "country": "Other",
                  "yearMonth": "2022-01",
                  "assessmentType": "SAP" }] }
    end
  end
end