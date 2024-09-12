describe Domain::StatisticsResults do
  subject(:domain) { described_class.new(register_data:, warehouse_data:) }

  let(:register_data) { ServicePerformance::CountryStatsStub.body[:data][:assessments] }
  let(:warehouse_data) { ServicePerformance::AverageCo2EmissionsStub.body[:data] }

  describe "#match_date_and_country" do
    it "returns the matching value from the warehouse data" do
      expect(domain.match_date_and_country(month: "2021-09", country: :england)).to eq [{ average_co2: 15.73676647, country: "England", yearMonth: "2021-09" }]
      expect(domain.match_date_and_country(month: "2021-09", country: :northernIreland)).to eq [{ average_co2: 34.345225235, country: "Northern Ireland", yearMonth: "2021-09" }]
    end
  end

  describe "#avg_co2" do
    context "when there is a match" do
      it "returns the average co2 for the matching date and country" do
        matched_date_and_country = [{ average_co2: 15.73676647, country: "England", yearMonth: "2021-09" }]
        expect(domain.avg_co2(matched_date_and_country:)).to eq 15.74
      end
    end

    context "when there is no match" do
      it "returns nil" do
        matched_date_and_country = []
        expect(domain.avg_co2(matched_date_and_country:)).to be_nil
      end
    end
  end

  describe "#update" do
    it "updates the register data with the avg CO2 emission value" do
      epc_by_country = [{ numAssessments: 20_444, assessmentType: "SAP", ratingAverage: 78.3304347826087, month: "2021-07" },
                        { numAssessments: 23_866, assessmentType: "SAP", ratingAverage: 76.9909090909091, month: "2021-01" },
                        { numAssessments: 8422, assessmentType: "SAP", ratingAverage: 79.6190476190476, month: "2021-12" },
                        { numAssessments: 261_069, assessmentType: "SAP", ratingAverage: 77.2258064516129, month: "2020-10" }]
      avg_co2 = 13.56
      date = "2021-07"
      domain.update(epc_by_country:, avg_co2:, date:)
      expect(epc_by_country.first[:avgCo2Emission]).to eq(avg_co2)
      (1..(epc_by_country.length - 1)).each do |i|
        expect(epc_by_country[i][:avgCo2Emission]).to be_nil
      end
    end
  end

  describe "#set_results" do
    it "joins the register data with the warehouse data" do
      domain.set_results
      expect(domain.results[:england]).to include({ assessmentType: "SAP", avgCo2Emission: 15.74, country: "England", month: "2021-09", numAssessments: 112_499, ratingAverage: 61.7122807017544 })
      expect(domain.results[:northernIreland]).to include({ assessmentType: "SAP", avgCo2Emission: 34.35, country: "Northern Ireland", month: "2021-09", numAssessments: 4892, ratingAverage: 61.7122807017544 })
      expect(domain.results[:wales]).to include({ assessmentType: "SAP", avgCo2Emission: 23.27, country: "Wales", month: "2021-09", numAssessments: 4892, ratingAverage: 61.7122807017544 })
      expect(domain.results[:other]).to include({ assessmentType: "SAP", avgCo2Emission: 21.13, country: "Other", month: "2021-09", numAssessments: 4892, ratingAverage: 61.7122807017544 })
    end
  end

  describe "#grouped_by_assessment_type_and_country" do
    it "groups the assessments data by the assessment types and country", :aggregate_failures do
      domain.set_results
      results = domain.grouped_by_assessment_type_and_country
      assessment_types = %w[SAP RdSAP CEPC DEC AC-CERT DEC-RR]
      expect(results.length).to eq(assessment_types.length)
      expect(results.keys - assessment_types).to eq([])

      expect(results["CEPC"]).to eq({
        "England" => [
          { assessmentType: "CEPC", country: "England", month: "2021-09", numAssessments: 92_124, ratingAverage: 47.7122807017544 },
        ],
        "Wales" => [
          { assessmentType: "CEPC", country: "Wales", month: "2021-09", numAssessments: 874, ratingAverage: 47.7122807017544 },
        ],
        "Northern Ireland" => [
          { assessmentType: "CEPC", country: "Northern Ireland", month: "2021-09", numAssessments: 874, ratingAverage: 47.7122807017544 },
        ],
        "Other" => [
          { assessmentType: "CEPC", country: "Other", month: "2021-09", numAssessments: 26, ratingAverage: 61.7122807017544 },
        ],
        "all" => [
          { assessmentType: "CEPC", country: "all", month: "2020-11", numAssessments: 144_533, ratingAverage: 71.85 },
          { assessmentType: "CEPC", country: "all", month: "2021-11", numAssessments: 2837, ratingAverage: 66.24 },
          { assessmentType: "CEPC", country: "all", month: "2021-02", numAssessments: 6514, ratingAverage: 72.843537414966 },
        ],
      })
    end
  end

  describe "#get_results" do
    it "returns the results" do
      domain.set_results
      result = domain.get_results
      expect(result[:assessments][:grouped]).not_to eq []
    end
  end
end
