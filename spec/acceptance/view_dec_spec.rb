# frozen_string_literal: true

describe "Acceptance::DisplayEnergyCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        assessment_id: "0000-0000-0000-0000-1111", date_of_expiry: "2030-02-21",
      )
    end

    it "shows the page title" do
      expect(response.body).to include("Display Energy Certificate")
    end

    it "shows the contents section" do
      expect(response.body).to have_css "h2", text: "Certificate contents"
      expect(response.body).to have_link "Energy performance of this building",
                                         href: "#rating"
      expect(response.body).to have_link "Previous operational ratings",
                                         href: "#previous_energy_ratings"
      expect(response.body).to have_link "Total CO2 emissions", href: "#co2"
      expect(response.body).to have_link "Technical information",
                                         href: "#technical_information"
      expect(response.body).to have_link "Administrative information",
                                         href: "#administrative_information"
      expect(response.body).to have_link "Other certificates for this property",
                                         href: "#other_certificates"
    end

    it "shows the summary box" do
      expect(response.body).to include("0000-0000-0000-0000-1111")
      expect(response.body).to include("Valid until 21 February 2030")
      expect(response.body).to include("A")
      expect(response.body).to include("2 Lonely Street")
      expect(response.body).to include("Post-Town1")
      expect(response.body).to include("A0 0AA")
      expect(response.body).to have_text "Print this certificate"
    end

    it "shows the rating section" do
      expect(response.body).to have_css "h2",
                                        text: "Energy performance of this building"
      expect(response.body).to have_css "p",
                                        text:
                                          "The building’s operational energy performance rating is based on its carbon dioxide (CO2) emissions for the last year."
      expect(response.body).to have_css "p",
                                        text:
                                          "It is given a score and an operational rating on a scale from A (lowest emissions) to G (highest emissions)."
      expect(response.body).to have_css "p",
                                        text:
                                          "Typical operational score for a public building is 100. This typical score gives an operational rating of D."
      expect(response.body).to have_css "text", text: "1 | A"
      expect(response.body).to have_css "p",
                                        text:
                                          "You can read guidance on Display Energy Certificates and advisory reports for public buildings."
      expect(
        response.body,
      ).to have_link "guidance on Display Energy Certificates and advisory reports for public buildings",
                     href:
                       "https://www.gov.uk/government/publications/display-energy-certificates-and-advisory-reports-for-public-buildings"
    end

    it "shows the previous operational ratings section" do
      expect(response.body).to have_css "h2", text: "Previous operational ratings"
      expect(response.body).to have_css "dt", text: "January 2020"
      expect(response.body).to have_css "dd", text: "1 | A"
      expect(response.body).to have_css "dt", text: "January 2019"
      expect(response.body).to have_css "dd", text: "24 | A"
      expect(response.body).to have_css "dt", text: "January 2018"
      expect(response.body).to have_css "dd", text: "40 | B"
    end

    it "shows the total CO2 emissions section" do
      expect(response.body).to include("Total CO2 emissions")
      expect(response.body).to include(
        "This tells you how much carbon dioxide the building emits. It shows tonnes per year of CO2.",
      )
      expect(response.body).to have_css "th.govuk-table__header", text: "Date"
      expect(response.body).to have_css "th.govuk-table__header",
                                        text: "January 2020"
      expect(
        response.body,
      ).to have_css "th.govuk-table__header.govuk-table__header--numeric",
                    text: "Electricity"
      expect(
        response.body,
      ).to have_css "td.govuk-table__cell.govuk-table__cell--numeric", text: "7"
      expect(
        response.body,
      ).to have_css "th.govuk-table__header.govuk-table__header--numeric",
                    text: "Heating"
      expect(
        response.body,
      ).to have_css "td.govuk-table__cell.govuk-table__cell--numeric", text: "3"
      expect(
        response.body,
      ).to have_css "th.govuk-table__header.govuk-table__header--numeric",
                    text: "Renewables"
      expect(
        response.body,
      ).to have_css "td.govuk-table__cell.govuk-table__cell--numeric", text: "0"
    end

    it "shows the technical information section" do
      expect(response.body).to have_css "h2", text: "Technical information"
      expect(response.body).to have_css "p",
                                        text:
                                          "This tells you technical information about how energy is used in this building. Consumption data based on actual meter readings."
      expect(response.body).to have_css "dt", text: "Main heating fuel"
      expect(response.body).to have_css "dd", text: "Natural Gas"
      expect(response.body).to have_css "dt", text: "Building environment"
      expect(response.body).to have_css "dd",
                                        text: "Heating and Natural Ventilation"
      expect(response.body).to have_css "dt", text: "Total useful floor area"
      expect(response.body).to have_css "dd", text: "99 square metres"
      expect(response.body).to have_css "dt", text: "Asset rating"
      expect(response.body).to have_css "dd", text: "1"
      expect(response.body).to have_css "th", text: "Energy use"
      expect(response.body).to have_css "th", text: "Heating"
      expect(response.body).to have_css "th", text: "Electricity"
      expect(response.body).to have_css "th",
                                        text: "Annual energy use (kWh/m2/year)"
      expect(response.body).to have_css "td", text: "11"
      expect(response.body).to have_css "td", text: "12"
      expect(response.body).to have_css "th",
                                        text: "Typical energy use (kWh/m2/year)"
      expect(response.body).to have_css "td", text: "13"
      expect(response.body).to have_css "td", text: "14"
      expect(response.body).to have_css "th", text: "Energy from renewables"
      expect(response.body).to have_css "td", text: "15%"
      expect(response.body).to have_css "td", text: "16%"
    end

    describe "viewing the Administrative information section" do
      it "shows the section heading" do
        expect(response.body).to have_css "h2",
                                          text: "Administrative information"
        expect(response.body).to have_css "p",
                                          text:
                                            "This is a Display Energy Certificate as defined in the Energy Performance of Buildings Regulations 2012 as amended."
        expect(response.body).to have_css "dt", text: "Assessment software"
        expect(response.body).to have_css "dd", text: "DCLG, ORCalc, v3.6.3"
        expect(response.body).to have_css "dt", text: "Property reference"
        expect(response.body).to have_css "dd", text: "UPRN-000000000001"
        expect(response.body).to have_css "dt", text: "Assessor name"
        expect(response.body).to have_css "dd", text: "TEST NAME BOI"
        expect(response.body).to have_css "dt", text: "Assessor number"
        expect(response.body).to have_css "dd", text: "SPEC000000"
        expect(response.body).to have_css "dt", text: "Accreditation scheme"
        expect(response.body).to have_css "dd", text: "Quidos"
        expect(response.body).to have_css "dt",
                                          text: "Accreditation scheme telephone"
        expect(response.body).to have_css "dd", text: "01225 667 570"
        expect(response.body).to have_css "dt",
                                          text: "Accreditation scheme email"
        expect(response.body).to have_css "dd", text: "info@quidos.co.uk"
        expect(response.body).to have_css "dt", text: "Employer/Trading name"
        expect(response.body).to have_css "dd", text: "Joe Bloggs Ltd"
        expect(response.body).to have_css "dt", text: "Employer/Trading address"
        expect(response.body).to have_css "dd",
                                          text: "123 My Street, My City, AB3 4CD"
        expect(response.body).to have_css "dt", text: "Issue date"
        expect(response.body).to have_css "dd", text: "14 May 2020"
        expect(response.body).to have_css "dt", text: "Nominated date"
        expect(response.body).to have_css "dd", text: "1 January 2020"
        expect(response.body).to have_css "dt", text: "Valid until"
        expect(response.body).to have_css "dd", text: "21 February 2030"
        expect(response.body).to have_css "dt", text: "Related party disclosure"
        expect(response.body).to have_css "dd",
                                          text:
                                            "The assessor has not indicated whether they have a relation to this property."
        expect(response.body).to have_css "p",
                                          text:
                                            "Recommendations for improving the energy performance of the building are contained in the associated Recommendation Report."
        expect(response.body).to have_link "Recommendation Report",
                                           href:
                                             "/energy-performance-certificate/4192-1535-8427-8844-6702"
      end
    end

    context "with different related party disclosure codes" do
      it "shows the corresponding related party disclosure text" do
        related_party_disclosures = {
          "1": "Not related to the occupier.",
          "2": "Employed by the occupier.",
          "3": "Contractor to the occupier for EPBD services only.",
          "4": "Contractor to the occupier for non-EPBD services.",
          "5": "Indirect relation to the occupier.",
          "6": "Financial interest in the occupier and/or property.",
          "7": "Previous relation to the occupier.",
          "8":
            "The assessor has not indicated whether they have a relation to this property.",
        }

        related_party_disclosures.each do |key, disclosure|
          FetchAssessmentSummary::AssessmentStub.fetch_dec(
            assessment_id: "0000-0000-0000-0000-1111",
            date_of_expiry: "2030-02-21",
            related_party: key,
          )

          response =
            get "/energy-performance-certificate/0000-0000-0000-0000-1111"

          expect(response.body).to have_css "dd", text: disclosure
        end
      end
    end

    it "shows the Other reports for this property section" do
      expect(response.body).to have_css "h2",
                                        text: "Other DECs for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous certificates for this property and they are not listed here, please contact the Help Desk at 01632 164 6672."
      expect(response.body).to have_css "dt", text: "Reference number"
      expect(response.body).to have_link "0000-0000-0000-0000-0001",
                                         href: "/energy-performance-certificate/0000-0000-0000-0000-0001"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).not_to have_link "0000-0000-0000-0000-0002",
                                             href: "/energy-performance-certificate/0000-0000-0000-0000-0002"
      expect(response.body).not_to have_css "dd", text: "4 May 2019 (Expired)"
    end

    context "when there are no related assessments" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_dec(
          assessment_id: "0000-0000-0000-0000-1111", related_assessments: [],
        )
      end

      it "shows the related assessments section title" do
        expect(response.body).to have_css "h2",
                                          text: "Other DECs for this property"
      end

      it "shows the no related assessments content" do
        expect(response.body).to have_css "p",
                                          text: "There are no related certificates for this property."
      end
    end
  end
end
