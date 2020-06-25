describe "Acceptance::Certificate" do
  include RSpecFrontendServiceMixin

  context "when the assessment exists" do
    before { FetchCertificate::NonDomesticStub.fetch assessment_id: "123-456" }

    let(:response) { get "/energy-performance-certificate/123-456" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "shows the EPC title" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Non-domestic Energy Performance Certificate</h1>',
      )
    end
  end
end
