describe Gateway::InterestingNumbersGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  describe "#fetch" do
    let(:response) { gateway.fetch }

    before do
      Reporting::InterestingNumbersStub.fetch
    end

    it "calls the method and returns the expected hash" do
      expect(response).to be_a(Hash)
    end

    it "returns a hash includes the correct name" do
      expect(response[:data][0][:name]).to eq "heat_pump_count_for_sap"
    end

    it "returns a hash includes the the data set", :aggregate_failures do
      expect(response[:data][0][:data].length).to eq 12
      expect(response[:data][0][:data].first).to eq({ monthYear: "2021-12", numEpcs: 929 })
      expect(response[:data][0][:data].select { |i| i[:monthYear] == "2022-02" }.first[:numEpcs]).to eq 1258
    end

    context "when the API returns a 202 reponse status" do
      before do
        Reporting::InterestingNumbersStub.fetch_202
      end

      let(:error_response) { gateway.fetch }

      it "raises a report incomplete error" do
        expect { error_response }.to raise_error(Errors::ReportIncomplete)
      end
    end
  end
end
