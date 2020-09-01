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
      expect(response.body).to have_css "dt", text: "F-Gas compliant date"
      expect(response.body).to have_css "dd", text: "20 September 2010"
      expect(response.body).to have_css "dt", text: "Total effective rated output"
      expect(response.body).to have_css "dd", text: "106 kW"
    end
  end

  context "when F-Gas compliant date is Not Provided" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
        f_gas_compliant_date: "Not Provided",
      )
    end

    it "shows Not Provided" do
      expect(response.body).to have_css "dt", text: "F-Gas compliant date"
      expect(response.body).to have_css "dd", text: "Not Provided"
    end
  end
end
