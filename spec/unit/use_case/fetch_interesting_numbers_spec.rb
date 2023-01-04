describe UseCase::FetchInterestingNumbers do
  include RSpecUnitMixin
  let(:interesting_numbers_gateway) { Gateway::InterestingNumbersGateway.new(get_api_client) }
  let(:use_case) { described_class.new(interesting_numbers_gateway) }

  before do
    Reporting::InterestingNumbersStub.fetch
  end

  it "fetches all the data" do
    expect(use_case.execute[:data].length).to eq(2)
  end

  it "fetches the heatpump data" do
    data = use_case.execute("heat_pump_count_for_sap")
    expect(data.length).to eq(12)
    expect(data).to match a_hash_including({ monthYear: "2022-04", numEpcs: 1 })
  end

  context "when there is a 202" do
    before do
      Reporting::InterestingNumbersStub.fetch_202
    end

    it "re raises the error" do
      expect { use_case.execute }.to raise_error(Errors::ReportIncomplete)
    end
  end
end
