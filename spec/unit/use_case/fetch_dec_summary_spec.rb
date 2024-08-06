describe UseCase::FetchDecSummary do
  context "when a DEC exists" do
    before do
      CertificatesGateway::UnsupportedSchemaStub.fetch_dec_summary(
        "0000-0000-0000-0000-0001",
      )
    end

    let(:use_case_object) do
      container = Container.new
      container.get_object(:fetch_dec_summary_use_case)
    end

    it "returns the certificate" do
      expect {
        use_case_object.execute("0000-0000-0000-0000-0001")
      }.to raise_error(Errors::AssessmentUnsupported)
    end
  end

  context "when there is a request with a badly formatted RRN" do
    let(:gateway) { instance_double(Gateway::CertificatesGateway) }
    let(:fetch_dec) { described_class.new(gateway) }

    describe "#execute" do
      before do
        allow(gateway).to receive(:fetch_dec_summary).and_return("blah")
      end

      it "returns a Not Found without calling the gateway" do
        expect {
          fetch_dec.execute("not-an-rrn-12345678")
        }.to raise_error(Errors::AssessmentNotFound)
        expect(gateway).not_to have_received :fetch_dec_summary
      end
    end
  end
end
