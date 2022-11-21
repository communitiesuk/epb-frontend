describe "Acceptance::NonDomesticEnergyPerformanceCertificateRecommendationReportPrintView", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the report is superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2010-01-05",
        related_energy_band: "b",
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "shows an superseded warning message" do
      expect(print_response.body).to have_css(".govuk-warning-text", text: "A new report has replaced this one")
    end

    it "does not show warning text for expiry" do
      expect(print_response.body).not_to have_css(".govuk-warning-text", text: "This report has expired")
    end
  end

  context "when the report is expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2010-01-05",
        related_energy_band: "b",
        superseded_by: nil,
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "does not show an superseded warning message" do
      expect(print_response.body).not_to have_css(".govuk-warning-text", text: "A new report has replaced this one")
    end

    it "shows warning text for expiry" do
      expect(print_response.body).to have_css(".govuk-warning-text", text: "This report has expired")
    end
  end
end
