require_relative "./shared_statistics"

describe Domain::StatisticsResults do
  subject(:domain) { described_class.new(register_data:, warehouse_data:) }

  let(:register_data) { ServicePerformance::CountryStatsStub.body[:data][:assessments] }
  let(:warehouse_data) { ServicePerformance::AverageCo2EmissionsStub.body[:data] }

  describe "#match_with_warehouse" do
    it "returns the matching value from the warehouse data" do
      expect(domain.match_with_warehouse(month: "2021-09", country: :england, assessment_type: "RdSAP")).to eq [{ assessmentType: "RdSAP", avgCo2Emission: 10, country: "England", yearMonth: "2021-09" }]
      expect(domain.match_with_warehouse(month: "2022-03", country: :northernIreland, assessment_type: "SAP")).to eq [{ assessmentType: "SAP", avgCo2Emission: 34, country: "Northern Ireland", yearMonth: "2022-03" }]
    end

    context "when the value of the country key is ':all'" do
      it "returns the matching value as expected without a country key in the data warehouse item" do
        expect(domain.match_with_warehouse(month: "2021-09", country: :all, assessment_type: "SAP")).to eq [{ "avgCo2Emission": 16, "yearMonth": "2021-09", "assessmentType": "SAP" }]
      end
    end

    context "when a country is passed which is not in the warehouse data" do
      it "returns an empty array" do
        expect(domain.match_with_warehouse(month: "2021-09", country: :fakeCountry, assessment_type: "SAP")).to eq []
      end
    end
  end

  describe "#avg_co2" do
    context "when there is a match with the warehouse data" do
      it "returns the average co2 for the matching data" do
        matched_date_and_country = [{ assessmentType: "SAP", avgCo2Emission: 34, country: "Northern Ireland", yearMonth: "2022-03" }]
        expect(domain.avg_co2(matched_date_and_country:)).to eq 34
      end
    end

    context "when there is no matching data" do
      it "returns nil" do
        matched_date_and_country = []
        expect(domain.avg_co2(matched_date_and_country:)).to be_nil
      end
    end
  end

  describe "#update" do
    context "when there is a CO2 value" do
      it "updates the register data with the avg CO2 emission value" do
        reg_data = [{ numAssessments: 20_444, assessmentType: "SAP", ratingAverage: 78.3304347826087, month: "2021-07" }]
        avg_co2 = 13
        date = "2021-07"
        assessment_type = "SAP"
        domain.update(list: reg_data, avg_co2:, date:, assessment_type:)
        expect(reg_data.first[:avgCo2Emission]).to eq(avg_co2)
      end
    end

    context "when the CO2 value is nil" do
      it "does not update the register data with a avgCo2Emission key" do
        reg_data = [{ numAssessments: 20_444, assessmentType: "SAP", ratingAverage: 78.3304347826087, month: "2021-07" }]
        avg_co2 = nil
        date = "2021-07"
        assessment_type = "SAP"
        domain.update(list: reg_data, avg_co2:, date:, assessment_type:)
        expect(reg_data.first.key?(:avgCo2Emission)).to be false
      end
    end
  end

  describe "#set_results" do
    before do
      domain.set_results
    end

    it "matches and joins the expected values" do
      expect(domain.results[:england]).to include({ assessmentType: "SAP", avgCo2Emission: 15, country: "England", month: "2021-09", numAssessments: 112_499, ratingAverage: 61.7122807017544 })
      expect(domain.results[:england]).to include({ assessmentType: "RdSAP", avgCo2Emission: 10, country: "England", month: "2021-09", numAssessments: 121_499, ratingAverage: 61.7122807017544 })
      expect(domain.results[:all]).to include({ assessmentType: "RdSAP", avgCo2Emission: 10, month: "2021-09", numAssessments: 121_499, ratingAverage: 61.7122807017544 })
    end

    context "when there is no corresponding result from the warehouse data" do
      it "does not modify the register data" do
        expect(domain.results[:wales]).to eq register_data[:wales]
      end
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

  describe "#get_country_results" do
    before do
      domain.set_results
    end

    context "when passing northern-ireland as the country" do
      it "returns the items for that the country key" do
        result = domain.get_country_results(country: "northern-ireland")
        grouped = result.group_by { |i| i[:country] }.flatten
        expect(grouped.first).to eq "Northern Ireland"
        expect(grouped.length).to eq 2
        expect(grouped.last.length).to eq 6
      end
    end

    context "when passing England as the country" do
      it "returns the items for that the country key" do
        result = domain.get_country_results(country: "england")
        grouped = result.group_by { |i| i[:country] }.flatten
        expect(grouped.first).to eq "England"
        expect(grouped.length).to eq 2
        expect(grouped.last.length).to eq 6
      end
    end
  end

  describe "#to_csv_hash" do
    subject(:domain) do
      described_class.new(register_data: ServicePerformance::MonthsStatsDataStub.get_data[:data][:assessments],
                          warehouse_data: ServicePerformance::AverageCo2EmissionsStub.body[:data])
    end

    before do
      domain.set_results
    end

    include_examples "Domain::Statistics"

    context "when filtering for England" do
      let!(:result) do
        domain.to_csv_hash(country: "england")
      end

      it "returns an array of hashes that matches" do
        expect(result).to eq england
      end
    end

    context "when filtering for Northern Ireland" do
      let!(:result) do
        domain.to_csv_hash(country: "northern-ireland")
      end

      it "returns an array of hashes that matches" do
        expect(result).to eq northern_ireland
      end
    end

    context "when filtering all items/countries" do
      let!(:result) do
        domain.to_csv_hash(country: "all")
      end

      it "returns an array of hashes that matches" do
        expect(result).to eq all_countries
      end
    end
  end
end
