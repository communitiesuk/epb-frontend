# frozen_string_literal: true

describe "Acceptance::AirConditioningInspectionCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/0000-0000-0000-0000-9999" }

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
      )
    end

    it "shows the page title" do
      expect(response.body).to have_css "h1",
                                        text: "Air conditioning inspection certificate"
    end

    it "shows the contents section" do
      expect(response.body).to have_css "h2", text: "Certificate contents"
      expect(response.body).to have_css "p", text: "Assessment details"
      expect(response.body).to have_css "p", text: "Inspection report"
      expect(response.body).to have_css "p", text: "Subsystems inspected"
      expect(response.body).to have_css "p", text: "Administrative information"
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
      expect(response.body).to have_css "dt", text: "Assessor’s declaration"
      expect(response.body).to have_css "dd",
                                        text:
                                          "Not related to the owner/occupier or person who has technical control of the system or subcontractor."
      expect(response.body).to have_css "dt", text: "F-Gas compliant date"
      expect(response.body).to have_css "dd", text: "20 September 2010"
      expect(response.body).to have_css "dt",
                                        text: "Total effective rated output"
      expect(response.body).to have_css "dd", text: "106 kW"
      expect(response.body).to have_css "dt", text: "System sampling"
      expect(response.body).to have_css "dd", text: "Yes"
      expect(response.body).to have_css "dt", text: "Treated floor area"
      expect(response.body).to have_css "dd", text: "410 square metres"
      expect(response.body).to have_css "dt", text: "Subsystems metered"
      expect(response.body).to have_css "dd", text: "No"
      expect(response.body).to have_css "dt",
                                        text: "Total estimated refrigerant charge"
      expect(response.body).to have_css "dd", text: "73 kg"
    end

    it "shows the subsystems inspected section" do
      expect(response.body).to have_css "h2", text: "Subsystems inspected"
      expect(response.body).to have_css "th", text: "Subsystem ID"
      expect(response.body).to have_css "th", text: "Description"
      expect(response.body).to have_css "th", text: "Refrigerant type"
      expect(response.body).to have_css "th", text: "Age of main components"
      expect(response.body).to have_css "td",
                                        text:
                                          "VOL001/SYS001/CP001 Ground Floor Banking Hall, Interview Room and Cashiers Area"
      expect(response.body).to have_css "td",
                                        text:
                                          "Mitsubishi Electric PURY-P250LM-A1 VRF packaged system x 1 serve ceiling slot diffuser internal unit x 6"
      expect(response.body).to have_css "td", text: "R410A"
      expect(response.body).to have_css "td", text: "2013"
    end

    it "can show the Administrative information section" do
      expect(response.body).to have_css "h2", text: "Administrative information"
      expect(response.body).to have_css "dt", text: "Assessor’s name"
      expect(response.body).to have_css "dd", text: "TEST NAME BOI"
      expect(response.body).to have_css "dt", text: "Assessor ID"
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

    context "with different related party disclosure codes" do
      it "shows the corresponding related party disclosure text" do
        related_party_disclosures = {
          "1":
            "Not related to the owner/occupier or person who has technical control of the system or subcontractor.",
          "2": "Related to the property owner/occupier.",
          "3":
            "Related to the person who has technical control of the system or subcontractor.",
          "4": "Occupier of the property.",
          "5": "Owner or Director of the organisation.",
          "6":
            "Financial interest in the property/organisation with technical control of the system or subcontractor.",
          "7":
            "Contracted by the owner to provide other Energy Assessment services.",
          "8":
            "Contracted by the owner to provide other (non-Energy Assessment) services.",
          "9":
            "Contracted by the owner to provide air conditioning maintenance services.",
        }

        related_party_disclosures.each do |code, disclosure|
          FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
            assessment_id: "0000-0000-0000-0000-1111",
            related_party_disclosure: code,
          )

          response = get "/energy-certificate/0000-0000-0000-0000-1111"

          expect(response.body).to have_css "dd", text: disclosure
        end
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

    context "when System sampling is N" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
          assessment_id: "0000-0000-0000-0000-9999", system_sampling: "N",
        )
      end

      it "shows No" do
        expect(response.body).to have_css "dt", text: "System sampling"
        expect(response.body).to have_css "dd", text: "No"
      end
    end

    context "when Subsystem metered is 0" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
          assessment_id: "0000-0000-0000-0000-9999",
          system_sampling: "N",
          subsystems_metered: "0",
        )
      end

      it "shows Yes" do
        expect(response.body).to have_css "dt", text: "Subsystems metered"
        expect(response.body).to have_css "dd", text: "Yes"
      end
    end

    context "when Subsystem metered is 2" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
          assessment_id: "0000-0000-0000-0000-9999", subsystems_metered: "2",
        )
      end

      it "shows In part" do
        expect(response.body).to have_css "dt", text: "Subsystems metered"
        expect(response.body).to have_css "dd", text: "In part"
      end
    end

    it "shows the Inspection report section" do
      expect(response.body).to have_css "h2", text: "Inspection report"
      expect(response.body).to have_css "p",
                                        text:
                                          "For the assessor’s recommendations, see the inspection report."
      expect(response.body).to have_link "the inspection report",
                                         href: "/energy-certificate/0000-0000-0000-0000-8888"
    end
  end
end
