# frozen_string_literal: true

require_relative "./shared_language_toggle"
require_relative "./content_security_policy_behaviour"

describe "Acceptance::DisplayEnergyCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/0000-0000-0000-0000-1111" }

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        assessment_id: "0000-0000-0000-0000-1111",
        date_of_expiry: "2030-02-21",
      )
    end

    it "shows the page title" do
      expect(response.body).to include("Display energy certificate")
    end

    include_examples "show language toggle"

    it "has a tab content that shows" do
      expect(response.body).to include(
        " <title>Display energy certificate (DEC) – Find an energy certificate – GOV.UK</title>",
      )
    end

    it "shows the address without duplicated occupier or town in the summary box" do
      address =
        "Primary School" \
          "2 Lonely Street" \
          "Something road" \
          "Post-Town1" \
          "A0 0AA"
      expect(response.body).to have_css "p",
                                        class: "epc-address",
                                        exact_text: address
    end

    it "shows the contents section" do
      expect(response.body).to have_css "h2", text: "Certificate contents"
      expect(
        response.body,
      ).to have_link "Energy performance operational rating", href: "#rating"
      expect(response.body).to have_link "Recommendation report",
                                         href: "#recommendation_report"
      expect(response.body).to have_link "Previous operational ratings",
                                         href: "#previous_energy_ratings"
      expect(response.body).to have_link "Total carbon dioxide (CO2) emissions",
                                         href: "#co2"
      expect(response.body).to have_link "This building’s energy use",
                                         href: "#technical_information"
      expect(response.body).to have_link "Administrative information",
                                         href: "#administrative_information"
      expect(response.body).to have_link "Other certificates for this property",
                                         href: "#other_certificates_and_reports"
    end

    it "shows the share certificate section" do
      expect(response.body).to have_css "h2", text: "Share this certificate"
      expect(response.body).to have_link "Email"
      expect(response.body).to have_button "Copy link to clipboard", visible: :visible
      expect(response.body).to have_link "Print", visible: :all
    end

    it "shows the summary box" do
      expect(response.body).to have_css "p", text: "0000-0000-0000-0000-1111"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "p", text: "21 February 2030"
      expect(response.body).to have_css "p", text: "A"
    end

    it "shows the rating section" do
      expect(response.body).to have_css "h2",
                                        text: "Energy performance operational rating"
      expect(response.body).to have_css "p",
                                        text:
                                          "The building’s energy performance operational rating is based on its carbon dioxide (CO2) emissions for the last year."
      expect(response.body).to have_css "p",
                                        text:
                                          "It is given a score and an operational rating on a scale from A (lowest emissions) to G (highest emissions)."
      expect(response.body).to have_css "p",
                                        text:
                                          "The typical score for a public building is 100. This typical score gives an operational rating of D."
      expect(response.body).to have_css "text", text: "1 A"
      expect(response.body).to have_css "p",
                                        text:
                                          "You can read guidance on DECs and advisory reports for public buildings."
      expect(
        response.body,
      ).to have_link "guidance on DECs and advisory reports for public buildings",
                     href:
                       "https://www.gov.uk/government/publications/display-energy-certificates-and-advisory-reports-for-public-buildings"
    end

    it "shows the SVG alternative text title" do
      expect(response.body).to include(
        '<title id="svg-title">Operational energy efficiency chart</title>',
      )
    end

    it "shows the SVG alternative text description" do
      expect(response.body).to include(
        '<desc id="svg-desc">This building’s operational energy rating is A with a score of 1. Buildings get a rating from A to G and a score. Rating A is for a score of zero to 25. The ratings and scores are as follows from best to worst. Rating A is for a score of zero to 25. Rating B is for a score of 26 to 50. Rating C is for a score of 51 to 75. Rating D is for a score of 76 to 100. Rating E is for a score of 101 to 125. Rating F is for a score of 126 to 150. Rating G is for a score over 150.</desc>',
      )
    end

    it "shows the previous operational ratings section" do
      expect(response.body).to have_css "h2",
                                        text: "Previous operational ratings"
      expect(response.body).to have_css "dt", text: "January 2020"
      expect(response.body).to have_css "dd", text: "1 A"
      expect(response.body).to have_css "dt", text: "January 2019"
      expect(response.body).to have_css "dd", text: "24 A"
      expect(response.body).to have_css "dt", text: "January 2018"
      expect(response.body).to have_css "dd", text: "40 B"
    end

    it "show the recommendation report link" do
      expect(response.body).to have_css "h2", text: "Recommendation report"
      expect(response.body).to have_css "p",
                                        text:
                                          "Guidance on improving the energy performance operational rating of this building can be found in the recommendation report."
      expect(response.body).to have_link "recommendation report",
                                         href: "/energy-certificate/4192-1535-8427-8844-6702"
    end

    it "shows the total CO2 emissions section" do
      expect(response.body).to include("Total carbon dioxide (CO2) emissions")
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
      expect(response.body).to have_css "h2", text: "This building’s energy use"
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

    it_behaves_like "all script elements have nonce attributes"
    it_behaves_like "all style elements have nonce attributes"

    describe "viewing the Administrative information section" do
      it "shows the section heading" do
        expect(response.body).to have_css "h2",
                                          text: "Administrative information"
        expect(response.body).to have_css "dt", text: "Assessment software"
        expect(response.body).to have_css "dd", text: "DCLG, ORCalc, v3.6.3"
        expect(response.body).to have_css "dt", text: "Property reference"
        expect(response.body).to have_css "dd", text: "UPRN-000000000001"
        expect(response.body).to have_css "dt", text: "Assessor’s name"
        expect(response.body).to have_css "dd", text: "TEST NAME BOI"
        expect(response.body).to have_css "dt", text: "Assessor ID"
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
        expect(response.body).to have_css "dt", text: "Assessor’s declaration"
        expect(response.body).to have_css "dd",
                                          text:
                                            "The assessor has not indicated whether they have a relation to this property."
        expect(response.body).to have_css "dt", text: "Summary XML"
        expect(response.body).to have_link "Download summary",
                                           href:
                                             "/energy-certificate/0000-0000-0000-0000-1111/dec_summary"
        expect(response.body).to have_css "dd", text: "(XML, 4KB)"
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

          response = get "/energy-certificate/0000-0000-0000-0000-1111"

          expect(response.body).to have_css "dd", text: disclosure
        end
      end
    end

    it "shows the Other reports for this property section" do
      expect(response.body).to have_css "h2",
                                        text: "Other certificates for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous certificates for this property and they are not listed here, please contact us at mhclg.digital-services@communities.gov.uk or call our helpdesk on 020 3829 0748 (Monday to Friday, 9am to 5pm)."
      expect(response.body).to have_css "dt", text: "Certificate number"
      expect(response.body).to have_link "0000-0000-0000-0000-0001",
                                         href: "/energy-certificate/0000-0000-0000-0000-0001"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).not_to have_link "0000-0000-0000-0000-0002",
                                             href: "/energy-certificate/0000-0000-0000-0000-0002"
      expect(response.body).not_to have_css "dd", text: "4 May 2019 (Expired)"
    end

    context "when there are no related assessments" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_dec(
          assessment_id: "0000-0000-0000-0000-1111",
          related_assessments: [],
        )
      end

      it "shows the related assessments section title" do
        expect(response.body).to have_css "h2",
                                          text: "Other certificates for this property"
      end

      it "shows the no related assessments content" do
        expect(response.body).to have_css "p",
                                          text: "There are no related certificates for this property."
      end
    end

    context "when there is no Asset Rating" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_dec(
          assessment_id: "0000-0000-0000-0000-1111",
          date_of_expiry: "2030-02-21",
          asset_rating: nil,
        )
      end

      it "shows Not applicable" do
        expect(response.body).to have_css "dt", text: "Asset rating"
        expect(response.body).to have_css "dd", text: "1"
      end
    end

    context "when the schema version is not supported for dec xml summary" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_dec(
          assessment_id: "0000-0000-0000-0000-1111",
          date_of_expiry: "2008-02-21",
          asset_rating: nil,
          schema_version: 5.0,
        )
      end

      it "does not have summary download div" do
        expect(response.body).not_to have_css "dt", text: "Summary XML"
      end

      it "does not have summary download link" do
        expect(response.body).not_to have_link "Download summary"
      end
    end
  end

  context "when the dec is fetched in Welsh" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        assessment_id: "0000-0000-0000-0000-1111",
        date_of_expiry: "2030-02-21",
      )
    end

    let(:response) do
      get "/energy-certificate/0000-0000-0000-0000-1111?lang=cy"
    end

    it "shows the language toggle" do
      expect(response.body).to have_css "ul.language-toggle__list"
      expect(response.body).to have_link "English"
      expect(response.body).not_to have_link "Cymraeg"
    end
  end

  context "when a dec exists without a recommendation report" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        assessment_id: "0000-0000-0000-0000-1111",
        date_of_expiry: "2030-02-21",
        related_rrn: nil,
      )
    end

    it "excludes the recommendation report link from the contents section" do
      expect(response.body).to have_css "h2", text: "Certificate contents"
      expect(response.body).not_to have_link "Recommendation report",
                                             href: "#recommendation_report"
    end

    it "does not show the recommendation report link" do
      expect(response.body).not_to have_css "h2", text: "Recommendation report"
      expect(response.body).not_to have_css "p",
                                            text:
                                              "Guidance on improving the energy performance operational rating of this building can be found in the recommendation report."
      expect(response.body).not_to have_link "recommendation report"
    end
  end

  context "when a dec certificate is both NI and opted out" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        assessment_id: "0000-0000-0000-0000-1111",
        postcode: "BT1 1AA",
        opt_out: true,
        date_of_expiry: "2030-02-21",
      )
    end

    it "removes assessor contact details" do
      expect(response.body).to have_css "h2", text: "Administrative information"
      expect(response.body).to have_css "dt", text: "Assessment software"
      expect(response.body).to have_css "dd", text: "DCLG, ORCalc, v3.6.3"
      expect(response.body).to have_css "dt", text: "Property reference"
      expect(response.body).to have_css "dd", text: "UPRN-000000000001"
      expect(response.body).not_to have_css "dt", text: "Assessor’s name"
      expect(response.body).not_to have_css "dd", text: "TEST NAME BOI"
      expect(response.body).not_to have_css "dt", text: "Assessor ID"
      expect(response.body).not_to have_css "dd", text: "SPEC000000"
      expect(response.body).to have_css "dt", text: "Accreditation scheme"
      expect(response.body).to have_css "dd", text: "Quidos"
      expect(response.body).to have_css "dt",
                                        text: "Accreditation scheme telephone"
      expect(response.body).to have_css "dd", text: "01225 667 570"
      expect(response.body).to have_css "dt", text: "Accreditation scheme email"
      expect(response.body).to have_css "dd", text: "info@quidos.co.uk"
      expect(response.body).not_to have_css "dt", text: "Employer/Trading name"
      expect(response.body).not_to have_css "dd", text: "Joe Bloggs Ltd"
      expect(response.body).not_to have_css "dt",
                                            text: "Employer/Trading address"
      expect(response.body).not_to have_css "dd",
                                            text: "123 My Street, My City, AB3 4CD"
      expect(response.body).to have_css "dt", text: "Issue date"
      expect(response.body).to have_css "dd", text: "14 May 2020"
      expect(response.body).to have_css "dt", text: "Nominated date"
      expect(response.body).to have_css "dd", text: "1 January 2020"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "21 February 2030"
      expect(response.body).not_to have_css "dt", text: "Assessor’s declaration"
      expect(response.body).not_to have_css "dd",
                                            text:
                                              "The assessor has not indicated whether they have a relation to this property."
      expect(response.body).to have_css "dt", text: "Summary XML"
      expect(response.body).to have_link "Download summary",
                                         href: "/energy-certificate/0000-0000-0000-0000-1111/dec_summary"
      expect(response.body).to have_css "dd", text: "(XML, 4KB)"
    end
  end

  context "when a dec certificate has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
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
      expect(response.body).to have_css(".epc-extra-box p", text: "21 February 2012")
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
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
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
