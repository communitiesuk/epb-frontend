# frozen_string_literal: true

describe "Acceptance::AirConditioningInspectionCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-9999"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
      )
    end

    it "shows the page title" do
      expect(response.body).to have_css "h1",
                                        text: "Air Conditioning Inspection Certificate"
    end

    it "shows the summary section" do
      expect(response.body).to have_css "span", text: "66 Primrose Hill"
      expect(response.body).to have_css "span", text: "London"
      expect(response.body).to have_css "span", text: "SW1B 2BB"
      expect(response.body).to have_css "label", text: "Certificate number"
      expect(response.body).to have_css "span", text: "0000-0000-0000-0000-9999"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "span", text: "21 September 2024"
      expect(response.body).to have_text "Print this certificate"
    end

    it "shows the Assessment details section" do
      expect(response.body).to have_css "h2", text: "Assessment details"
      expect(response.body).to have_css "dt", text: "Inspection date"
      expect(response.body).to have_css "dd", text: "22 September 2019"
      expect(response.body).to have_css "dt", text: "Inspection level"
      expect(response.body).to have_css "dd", text: "Level 3"
      expect(response.body).to have_css "dt", text: "Assessment software"
      expect(response.body).to have_css "dd", text: "CLG, ACReport, v2.0"
    end
  end
end
