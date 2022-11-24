describe "Acceptance::NonDomesticEnergyPerformanceCertificateRecommendationReportPrintView", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the report is expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2020-01-01",
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "shows warning text for expiry" do
      expect(print_response.body).to have_css(".govuk-warning-text", text: "This report has expired")
    end
  end
end
