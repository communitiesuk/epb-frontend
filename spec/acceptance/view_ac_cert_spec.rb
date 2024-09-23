# frozen_string_literal: true

require_relative "./shared_language_toggle"
describe "Acceptance::AirConditioningInspectionCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/0000-0000-0000-0000-9999" }

  context "when an ac certificate exists" do
    before do
      Timecop.freeze(Time.utc(2023, 6, 21))
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
      )
    end

    it "shows the page heading" do
      expect(response.body).to have_css "h1",
                                        text: "Air conditioning inspection certificate"
    end

    include_examples "show language toggle"

    it "has a tab content that shows the page title" do
      expect(response.body).to include(
        " <title>Air conditioning inspection certificate – Find an energy certificate – GOV.UK</title>",
      )
    end

    it "shows the contents section" do
      expect(response.body).to have_css "h2", text: "Certificate contents"
      expect(response.body).to have_css "p", text: "Assessment details"
      expect(response.body).to have_css "p", text: "Inspection report"
      expect(response.body).to have_css "p", text: "Subsystems inspected"
      expect(response.body).to have_css "p", text: "Assessor’s details"
    end

    it "shows the share certificate section", :aggregate_failures do
      expect(response.body).to have_css "h2", text: "Share this certificate"
      expect(response.body).to have_link "Email"
      expect(response.body).to have_button "Copy link to clipboard", visible: :all
      expect(response.body).to have_link "Print", visible: :all
    end

    it "shows the summary section", :aggregate_failures do
      expect(response.body).to have_css "span", text: "66 Primrose Hill"
      expect(response.body).to have_css "span", text: "London"
      expect(response.body).to have_css "span", text: "SW1B 2BB"
      expect(response.body).to have_css "label", text: "Certificate number"
      expect(response.body).to have_css "span", text: "0000-0000-0000-0000-9999"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "span", text: "21 September 2024"
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

    it "can show the Assessor's details section" do
      expect(response.body).to have_css "h2", text: "Assessor’s details"
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
          assessment_id: "0000-0000-0000-0000-9999",
          system_sampling: "N",
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
          assessment_id: "0000-0000-0000-0000-9999",
          subsystems_metered: "2",
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

    context "when viewing the related certificates section" do
      it "shows the section title" do
        expect(response.body).to have_css(
          "h2",
          text: "Other certificates for this property",
        )
      end

      it "shows the related AC-CERT certificates" do
        expect(response.body).to have_link "0000-0000-0000-0000-0002",
                                           href: "/energy-certificate/0000-0000-0000-0000-0002"
      end
    end
  end

  context "when the assessment is fetched in Welsh" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
      )
    end

    let(:response) do
      get "/energy-certificate/0000-0000-0000-0000-9999?lang=cy"
    end

    it "shows the language toggle" do
      expect(response.body).to have_css "ul.language-toggle__list"
      expect(response.body).to have_link "English"
      expect(response.body).not_to have_link "Cymraeg"
    end
  end

  context "when an ac certificate expires" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
        date_of_expiry: "2012-05-21",
      )
    end

    it "shows the expired summary section" do
      expect(response.body).to have_css "label",
                                        text: "This certificate expired on"
      expect(response.body).to have_css "span", text: "21 May 2012"
    end
  end

  context "when an ac certificate is both NI and opted out" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-9999",
        postcode: "BT1 1AA",
        opt_out: true,
      )
    end

    it "removes assessor contact details" do
      expect(response.body).to have_css "h2", text: "Assessor’s details"
      expect(response.body).not_to have_css "dt", text: "Assessor’s name"
      expect(response.body).not_to have_css "dd", text: "TEST NAME BOI"
      expect(response.body).not_to have_css "dt", text: "Assessor ID"
      expect(response.body).not_to have_css "dd", text: "SPEC000000"
      expect(response.body).not_to have_css "dt", text: "Employer/Trading name"
      expect(response.body).not_to have_css "dd", text: "Joe Bloggs Ltd"
      expect(response.body).not_to have_css "dt",
                                            text: "Employer/Trading address"
      expect(response.body).not_to have_css "dd",
                                            text: "123 My Street, My City, AB3 4CD"
      expect(response.body).to have_css "dt", text: "Accreditation scheme"
      expect(response.body).to have_css "dd", text: "Quidos"
      expect(response.body).to have_css "dt",
                                        text: "Accreditation scheme telephone"
      expect(response.body).to have_css "dd", text: "01225 667 570"
      expect(response.body).to have_css "dt", text: "Accreditation scheme email"
      expect(response.body).to have_css "dd", text: "info@quidos.co.uk"
    end
  end

  context "when an ac certificate has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-1111",
        date_of_expiry: "2012-02-21",
        superseded_by: nil,
      )
    end

    let(:response) { get "/energy-certificate/0000-0000-0000-0000-1111" }

    it "shows the expired on message in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box label", text: "This certificate expired on")
    end

    it "shows the expired date in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box span", text: "21 February 2012")
    end

    it "shows an expired warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "This certificate has expired.")
    end

    it "shows a link to get the get service within the warning message" do
      expect(response.body).to have_css(".govuk-warning-text a")
      expect(response.body).to have_link("get a new certificate", href: "http://getting-new-energy-certificate.local.gov.uk:9393/")
    end
  end

  context "when a dec certificate has been superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_cert(
        assessment_id: "0000-0000-0000-0000-1111",
        date_of_expiry: "2012-02-21",
        superseded_by: "0000-1111-2222-3333-4444",
      )
    end

    let(:response) { get "/energy-certificate/0000-0000-0000-0000-1111" }

    it "shows an superseded warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "A new certificate has replaced this one.")
    end

    it "shows a link to get the get service within the warning message" do
      expect(response.body).to have_css(".govuk-warning-text a")
      expect(response.body).to have_link("See the new certificate", href: "/energy-certificate/0000-1111-2222-3333-4444")
    end
  end
end
