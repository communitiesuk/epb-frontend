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

    it "can show the Administrative information section" do
      expect(response.body).to have_css "h2", text: "Administrative information"
      expect(response.body).to have_css "dt", text: "Assessor name"
      expect(response.body).to have_css "dd", text: "TEST NAME BOI"
      expect(response.body).to have_css "dt", text: "Assessor number"
      expect(response.body).to have_css "dd", text: "SPEC000000"
      expect(response.body).to have_css "dt", text: "Accreditation scheme"
      expect(response.body).to have_css "dd", text: "Quidos"
      expect(response.body).to have_css "dt",
                                        text: "Accreditation scheme telephone"
      expect(response.body).to have_css "dd", text: "01225 667 570"
      expect(response.body).to have_css "dt", text: "Accreditation scheme email"
      expect(response.body).to have_css "dd", text: "info@quidos.co.uk"
      expect(response.body).to have_css "dt", text: "Employer/Trading name"
      expect(response.body).to have_css "dd", text: "Joe Bloggs Ltd"
      expect(response.body).to have_css "dt", text: "Employer/Trading address"
      expect(response.body).to have_css "dd",
                                        text: "123 My Street, My City, AB3 4CD"
    end

    it "can show the Executive summary section" do
      expect(response.body).to have_css "h2", text: "Executive summary"
      expect(response.body).to have_css "pre", text: "My\nSummary\t\tInspected"
    end

    it "can show the owner and operator section" do
      expect(response.body).to have_css "h2", text: "Equipment owner and operator"
      expect(response.body).to have_css "dt", text: "Owner name"
      expect(response.body).to have_css "dd", text: "Office manager"
      expect(response.body).to have_css "dt", text: "Owner organisation"
      expect(response.body).to have_css "dd", text: "The bank"
      expect(response.body).to have_css "dt", text: "Owner's phone number"
      expect(response.body).to have_css "dd", text: "01234"
      expect(response.body).to have_css "dt", text: "Owner's address"
      expect(response.body).to have_css "dd", text: "High street, North side, NEWCASTLE UPON TYNE, NE2 7DT"
      expect(response.body).to have_css "dt", text: "Operator responsible person"
      expect(response.body).to have_css "dd", text: "Chief engineer"
      expect(response.body).to have_css "dt", text: "Operator organisation"
      expect(response.body).to have_css "dd", text: "Air Con Ltd"
      expect(response.body).to have_css "dt", text: "Operator's phone number"
      expect(response.body).to have_css "dd", text: "44432"
      expect(response.body).to have_css "dt", text: "Operator's address"
      expect(response.body).to have_css "dd", text: "Low street, COVENTRY, CV11 2FF"
    end

    it "can show the key recommendations section" do
      expect(response.body).to have_css "h2", text: "Key recommendations"
    end
  end
end
