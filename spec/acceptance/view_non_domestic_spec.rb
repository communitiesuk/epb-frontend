describe "Acceptance::Certificate" do
  include RSpecFrontendServiceMixin

  context "when the assessment exists" do
    before { FetchCertificate::NonDomesticStub.fetch assessment_id: "123-456" }

    let(:response) { get "/energy-performance-certificate/123-456" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end
  end
end
