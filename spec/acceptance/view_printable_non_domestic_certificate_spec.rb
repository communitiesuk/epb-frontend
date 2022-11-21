describe "Acceptance::NonDomesticEnergyPerformanceCertificatePrintView", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the certificate has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc(
        assessment_id: "1234-5678-1234-5678-1234",
        expiry_date: "2010-01-05",
        energy_efficiency_band: "b",
        superseded_by: nil,
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "shows the warning text within a printable area" do
      expect(print_response.body).to have_css(".printable-area div.govuk-warning-text")
    end

    it "shows that the certificate has expired" do
      expect(print_response.body).to include(
        "This certificate has expired.",
      )
    end
  end
end
