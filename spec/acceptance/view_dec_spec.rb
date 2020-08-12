# frozen_string_literal: true

describe "Acceptance::DisplayEnergyCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        "0000-0000-0000-0000-1111",
        "2030-02-21",
      )
    end

    it "shows the page title" do
      expect(response.body).to include("Display Energy Certificate")
    end

    it "shows the summary box" do
      expect(response.body).to include("0000-0000-0000-0000-1111")
      expect(response.body).to include("Valid until 21 February 2030")
      expect(response.body).to include("A")
      expect(response.body).to include("2 Lonely Street")
      expect(response.body).to include("Post-Town1")
      expect(response.body).to include("A0 0AA")
    end

    it "shows the rating section" do
      expect(response.body).to include(
        ">Energy performance of this building</h2>",
      )
      expect(response.body).to include(
        "The building’s energy performance is based on its carbon dioxide (CO2) emissions for the last year.",
      )
      expect(response.body).to include(
        "It is given a score and an energy rating on a scale from A (lowest emissions) to G (highest emissions).",
      )
      expect(response.body).to include(
        "Typical energy performance for a public building is 100. This typical score gives an energy rating of D.",
      )
      expect(response.body).to include(">1 | A</text>")
      expect(response.body).to include(
        'You can read <a href="https://www.gov.uk/government/publications/display-energy-certificates-and-advisory-reports-for-public-buildings">guidance on Display Energy Certificates and advisory reports for public buildings</a>.',
      )
    end

    it "shows the previous operational ratings section" do
      expect(response.body).to include("Previous Operational Ratings")
      expect(response.body).to include("January 2020")
      expect(response.body).to include("1 | A")
      expect(response.body).to include("January 2019")
      expect(response.body).to include("24 | A")
      expect(response.body).to include("January 2018")
      expect(response.body).to include("40 | B")
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
      expect(response.body).to include(
        '<h2 class="govuk-heading-l">Technical Information</h2>',
      )
      expect(response.body).to include(
        "This tells you technical information about how energy is used in this building. Consumption data based on actual meter readings.",
      )
      expect(response.body).to include(">Main heating fuel</dt>")
      expect(response.body).to include(">Natural Gas</dd>")
      expect(response.body).to include(">Building environment</dt>")
      expect(response.body).to include(">Heating and Natural Ventilation</dd>")
      expect(response.body).to include(">Total useful floor area (m2)</dt>")
      expect(response.body).to include(">99</dd>")
      expect(response.body).to include(">Asset Rating</dt>")
      expect(response.body).to include(">1</dd>")
      expect(response.body).to include(">Energy use</th>")
      expect(response.body).to include(">Heating</th>")
      expect(response.body).to include(">Electricity</th>")
      expect(response.body).to include(">Annual Energy Use (kWh/m2/year)</th>")
      expect(response.body).to include(">11</td>")
      expect(response.body).to include(">12</td>")
      expect(response.body).to include(">Typical Energy Use (kWh/m2/year)</th>")
      expect(response.body).to include(">13</td>")
      expect(response.body).to include(">14</td>")
      expect(response.body).to include(">Energy from renewables</th>")
      expect(response.body).to include(">15%</td>")
      expect(response.body).to include(">16%</td>")
    end

    describe "viewing the Administrative information section" do
      it "shows the section heading" do
        expect(response.body).to have_css "h2", text: "Administrative information"
        expect(response.body).to have_css "p", text: "This is a Display Energy Certificate as defined in the Energy Performance of Buildings Regulations 2012 as amended."
        expect(response.body).to have_css "dt", text: "Assessment software"
        expect(response.body).to have_css "dd", text: "DCLG, ORCalc, v3.6.3"
        expect(response.body).to have_css "dt", text: "Property reference"
        expect(response.body).to have_css "dd", text: "UPRN-000000000001"
        expect(response.body).to have_css "dt", text: "Assessor name"
        expect(response.body).to have_css "dd", text: "TEST NAME BOI"
        expect(response.body).to have_css "dt", text: "Assessor number"
        expect(response.body).to have_css "dd", text: "SPEC000000"
        expect(response.body).to have_css "dt", text: "Accreditation scheme"
        expect(response.body).to have_css "dd", text: "test scheme"
        expect(response.body).to have_css "dt", text: "Employer/Trading Name"
        expect(response.body).to have_css "dd", text: "Joe Bloggs Ltd"
        expect(response.body).to have_css "dt", text: "Employer/Trading Address"
        expect(response.body).to have_css "dd", text: "123 My Street, My City, AB3 4CD"
        expect(response.body).to have_css "dt", text: "Issue date"
        expect(response.body).to have_css "dd", text: "14 May 2020"
        expect(response.body).to have_css "dt", text: "Nominated date"
        expect(response.body).to have_css "dd", text: "1 January 2020"
        expect(response.body).to have_css "dt", text: "Valid until"
        expect(response.body).to have_css "dd", text: "21 February 2030"
        expect(response.body).to have_css "dt", text: "Related party disclosure"
        expect(response.body).to have_css "dd", text: "The assessor has not indicated whether they have a relation to this property."
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
          "8": "The assessor has not indicated whether they have a relation to this property.",
        }

        related_party_disclosures.each do |key, disclosure|
          FetchAssessmentSummary::AssessmentStub.fetch_dec(
            "0000-0000-0000-0000-1111",
            "2030-02-21",
            true,
            key,
          )

          response =
            get "/energy-performance-certificate/0000-0000-0000-0000-1111"

          expect(response.body).to have_css "dd", text: disclosure

        end
      end
    end

    describe "viewing the related assessments section" do
      it "shows the related assessments section title" do
        expect(response.body).to include(
          ">Other certificates for this property</h2>",
        )
      end

      it "shows headings on the list of the related assessments" do
        expect(response.body).to include(">Reference number</p>")
        expect(response.body).to include(">Valid until</p>")
      end

      it "shows the expected valid related assessment" do
        expect(response.body).to include(
          "/energy-performance-certificate/0000-0000-0000-0000-0001\">0000-0000-0000-0000-0001</a>",
        )
        expect(response.body).to include(">Valid until 4 May 2026</b>")
      end

      it "shows the expected expired related assessment" do
        expect(response.body).to include(
          "/energy-performance-certificate/0000-0000-0000-0000-0002\">0000-0000-0000-0000-0002</a>",
        )
        expect(response.body).to include(">1 July 2002 (Expired)</b>")
      end

      context "when there are no related assessments" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_dec(
            "0000-0000-0000-0000-1111",
            "2030-02-21",
            false,
          )
        end

        it "shows the related assessments section title" do
          expect(response.body).to include(
            ">Other certificates for this property</h2>",
          )
        end

        it "shows the no related assessments content" do
          expect(response.body).to include(
            ">There are no related certificates for the property.</p>",
          )
        end
      end
    end
  end
end
