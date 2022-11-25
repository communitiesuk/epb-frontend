describe "Acceptance::PrintableAirConditioningCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the report is superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2020-01-01",
        superseded_by: "1234-5678-1234-5678-1235",
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "shows an superseded warning message" do
      expect(print_response.body).to have_css(".govuk-warning-text", text: "A new certificate has replaced this one")
    end

    it "does not show warning text for expiry" do
      expect(print_response.body).not_to have_css(".govuk-warning-text", text: "This certificate has expired")
    end
  end

  context "when the certificate is expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2020-01-01",
        superseded_by: nil,
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "shows warning text for expiry" do
      expect(print_response.body).to have_css(".govuk-warning-text", text: "This certificate has expired.")
    end
  end
end
