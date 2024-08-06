describe "Acceptance::DomesticEnergyPerformanceCertificatePrintView", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the certificate has been superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
      )
    end

    let(:print_response) { get "/energy-certificate/1234-5678-1234-5678-1234?print=true" }

    it "shows the warning text within a printable area" do
      expect(print_response.body).to have_css(".printable-area div.govuk-warning-text")
    end

    it "shows that the certificate has been superseded" do
      expect(print_response.body).to include(
        "This certificate is not valid. A new certificate has replaced this one.",
      )
    end

    it "does not show the related certificates section" do
      expect(print_response.body).not_to have_css(
        "h2",
        text: "Other certificates for this property",
      )
    end
  end

  context "when the certificate has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1111-1111-1111-1111-1119",
        expiry_date: "2010-01-05",
        superseded_by: nil,
      )
    end

    let(:print_response) { get "/energy-certificate/1111-1111-1111-1111-1119?print=true" }

    it "shows the warning text within a printable area" do
      expect(print_response.body).to have_css(".printable-area div.govuk-warning-text")
    end

    it "shows that the certificate has expired" do
      expect(print_response.body).to include(
        "This certificate has expired.",
      )
    end

    context "when the expired epc has been superseded" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1119",
          expiry_date: "2010-01-05",
        )
      end

      let(:print_response) { get "/energy-certificate/1111-1111-1111-1111-1119?print=true" }

      it "shows a superseded warning message" do
        expect(print_response.body).to have_css(".govuk-warning-text", text: "A new certificate has replaced this one")
      end

      it "does not show an expired warning message" do
        expect(print_response.body).not_to have_css(".govuk-warning-text", text: "This certificate has expired")
      end
    end
  end

  context "when the assessment exists with recommendations" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-1234-1234-1234-4567",
        recommended_improvements: true,
      )
    end

    let(:print_response) { get "/energy-certificate/1234-1234-1234-1234-4567?print=true" }

    it "shows a table with the recommendation steps" do
      expect(print_response.body).to have_css(".govuk-table__header", text: "Step")
    end

    it "shows the recommendation description" do
      expect(print_response.body).to have_css(".govuk-table__header", text: "2. Replace single glazed windows with low-E double glazed windows")
    end

    it "doesn't show the recommendation title" do
      expect(print_response.body).not_to include("Double glazed windows")
    end
  end
end
