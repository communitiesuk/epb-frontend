# frozen_string_literal: true

describe "Helpers.calculate_yearly_charges", type: :helper do
  subject(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  varying_charges = [
    {
      "endDate": "2038-05-31 00:00:00.000000",
      "startDate": "2015-06-01 00:00:00.000000",
      "dailyCharge": 1.9,
    },
    {
      "endDate": "2039-02-01 00:00:00.000000",
      "startDate": "2038-06-01 00:00:00.000000",
      "dailyCharge": 0.84,
    },
    {
      "endDate": "2039-02-02 00:00:00.000000",
      "startDate": "2039-02-02 00:00:00.000000",
      "dailyCharge": 0.95,
    },
  ]

  overlapping_charges = [
    {
      "endDate": "2038-05-31 00:00:00.000000",
      "startDate": "2015-06-01 00:00:00.000000",
      "dailyCharge": 1.9,
    },
    {
      "endDate": "2030-02-01 00:00:00.000000",
      "startDate": "2017-06-01 00:00:00.000000",
      "dailyCharge": 0.87,
    },
    {
      "endDate": "2039-02-02 00:00:00.000000",
      "startDate": "2039-02-02 00:00:00.000000",
      "dailyCharge": 0.84,
    },
  ]

  context "when given a green deal with a single charge" do
    charges = [
      {
        "endDate": "2038-05-31 00:00:00.000000",
        "startDate": "2015-06-01 00:00:00.000000",
        "dailyCharge": 1.00,
      },
    ]

    green_deal_plan = FetchAssessmentSummary::AssessmentStub.generate_green_deal_plan(charges)[0]

    before { allow(Date).to receive(:today).and_return Date.new(2021, 0o3, 29) }

    it "calculates the annual cost to the nearest whole pound" do
      expect(
        frontend_service_helpers.calculate_yearly_charges(green_deal_plan),
      ).to eq("365")
    end
  end

  context "when given a green deal with varying charges over time" do
    green_deal_plan = FetchAssessmentSummary::AssessmentStub.generate_green_deal_plan(varying_charges)[0]

    before { allow(Date).to receive(:today).and_return Date.new(2021, 0o3, 29) }

    it "calculates the annual cost when the current date is in charge #1" do
      expect(
        frontend_service_helpers.calculate_yearly_charges(green_deal_plan),
      ).to eq("694")
    end
  end

  context "when given a green deal with decreasing charges over time when current date is in charge #2" do
    green_deal_plan = FetchAssessmentSummary::AssessmentStub.generate_green_deal_plan(varying_charges)[0]

    before do
      allow(Date).to receive(:today).and_return Date.new(2038, 0o7, 0o1)
    end

    it "calculates the annual cost" do
      expect(
        frontend_service_helpers.calculate_yearly_charges(green_deal_plan),
      ).to eq("307")
    end
  end

  context "when given a green deal with decreasing charges over time when current date is in charge #3" do
    green_deal_plan = FetchAssessmentSummary::AssessmentStub.generate_green_deal_plan(varying_charges)[0]

    before do
      allow(Date).to receive(:today).and_return Date.new(2039, 0o2, 0o2)
    end

    it "calculates the annual cost" do
      expect(
        frontend_service_helpers.calculate_yearly_charges(green_deal_plan),
      ).to eq("347")
    end
  end

  context "when given a green deal with overlapping charges" do
    green_deal_plan =
      FetchAssessmentSummary::AssessmentStub.generate_green_deal_plan(overlapping_charges)[0]

    before { allow(Date).to receive(:today).and_return Date.new(2021, 0o3, 29) }

    it "calculates the combined annual cost when the current date is in the overlap period" do
      expect(
        frontend_service_helpers.calculate_yearly_charges(green_deal_plan),
      ).to eq("1012")
    end
  end
end
