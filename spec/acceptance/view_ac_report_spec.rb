# frozen_string_literal: true

describe "Acceptance::AirConditioningInspectionReport", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-9999"
  end

  context "when an ac report exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
          assessment_id: "0000-0000-0000-0000-9999",
          )
    end

    it "shows the page title" do
      expect(response.body).to have_css "h1",
                                        text: "Air conditioning inspection report"
    end

    it "shows the summary section" do
      expect(response.body).to have_css "span", text: "The Bank Plc"
      expect(response.body).to have_css "span", text: "49-51 Northumberland Street"
      expect(response.body).to have_css "span", text: "NE1 7AF"
      expect(response.body).to have_css "label", text: "Certificate number"
      expect(response.body).to have_css "span", text: "0000-0000-0000-0000-9999"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "span", text: "6 February 2025"
      expect(response.body).to have_text "Print this certificate"
    end
  end
end
