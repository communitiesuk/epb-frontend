# frozen_string_literal: true

require_relative "./shared_language_toggle"
describe "Acceptance::DomesticEnergyPerformanceCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the assessment exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "shows the EPC heading" do
      expect(response.body).to include("Energy performance certificate")
    end

    include_examples "show language toggle"

    it "has a tab content that shows the page title" do
      expect(response.body).to include(
        " <title>Energy performance certificate (EPC) – Find an energy certificate – GOV.UK</title>",
      )
    end

    it "shows the share certificate section" do
      expect(response.body).to have_css "h2", text: "Share this certificate"
      expect(response.body).to have_link "Email"
      expect(response.body).to have_button "Copy link to clipboard", visible: :all
      expect(response.body).to have_link "Print", visible: :all
    end

    it "URL encodes the mailto link appropriately" do
      expect(response.body).to include "mailto:?subject=Energy%20performance%20certificate%20%28EPC%29%20for%20Flat%2033%2C%202%20Marsham%20Street&amp;body=Please%20find%20your%20energy%20performance%20certificate%20%28EPC%29%20at%20https%3A%2F%2Ffind-energy-certificate.service.gov.uk%2Fenergy-certificate%2F1234-5678-1234-5678-1234"
    end

    it "shows the address summary" do
      expect(response.body).to include("Flat 33")
      expect(response.body).to include("2 Marsham Street")
      expect(response.body).to include("London")
      expect(response.body).to include("SW1B 2BB")
    end

    it "doesn't show town name twice" do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
        current_rating: 90,
        current_band: "b",
        current_carbon_emission: "2.4",
        potential_carbon_emission: "1.4",
        impact_of_loft_insulation: -79,
        impact_of_cavity_insulation: -67,
        impact_of_solid_wall_insulation: -69,
        address_line3: "London",
        postcode: "SW1B 2BB",
      )

      expect(response.body).to have_css "p",
                                        text: "Flat 332 Marsham StreetLondonSW1B 2BB"
    end

    it "shows the certificate number" do
      expect(response.body).to include("1234-5678-1234-5678-1234")
    end

    it "shows the date of assessment" do
      expect(response.body).to include("5 January 2020")
    end

    it "shows the registered date of the certificate" do
      expect(response.body).to include("2 January 2020")
    end

    it "shows the date of expiry" do
      expect(response.body).to include("5 January 2030")
    end

    it "shows the type of assessment" do
      expect(response.body).to have_selector("span.govuk-visually-hidden", text: "Show information about the ")
      expect(response.body).to have_selector("span.govuk-details__summary-text", text: "RdSAP")
    end

    it "shows the type of assessment description" do
      expect(response.body).to include(
        "RdSAP (Reduced data Standard Assessment Procedure) is a method used to assess and compare the energy and environmental performance of properties in the UK",
      )
    end

    it "shows the total floor area" do
      expect(response.body).not_to include(
        '<dd class="govuk-summary-list__value govuk-!-width-one-half">
          150 square metres
          </dd>',
      )
    end

    it "shows the type of dwelling" do
      expect(response.body).not_to include(
        '<dd class="govuk-summary-list__value govuk-!-width-one-half">
          Top floor flat.
          </dd>',
      )
    end

    it "shows the EPC rating text" do
      expect(response.body).to have_css "p",
                                        text: "This property’s energy rating is B."
    end

    it "shows the SVG with energy ratings" do
      expect(response.body).to include('<svg width="615"')
    end

    it "shows the SVG alternate text title" do
      expect(response.body).to include(
        '<title id="svg-title">Energy efficiency chart</title>',
      )
    end

    it "shows the SVG alternate text description" do
      expect(response.body).to include(
        '<desc id="svg-desc">This property’s energy rating is B with a score of 90. It has a potential energy rating of A with a score of 99. Properties get a rating from A to G and a score. Rating B is for a score of 81 to 91. The ratings and scores are as follows from best to worst. Rating A is for a score of 92 or more. Rating B is for a score of 81 to 91. Rating C is for a score of 69 to 80. Rating D is for a score of 55 to 68. Rating E is for a score of 39 to 54. Rating F is for a score of 21 to 38. Rating G is for a score of 1 to 20.</desc>',
      )
    end

    it "shows the SVG with energy rating band numbers" do
      expect(response.body).to include('<tspan x="8" y="55">92+</tspan>')
    end

    it "shows the assessors full name" do
      expect(response.body).to include("Test Boi")
    end

    it "shows the assessors accreditation scheme" do
      expect(response.body).to include("Elmhurst Energy")
    end

    it "shows the assessors accreditation number" do
      expect(response.body).to include("TESTASSESSOR")
    end

    it "shows the accreditation scheme telephone number" do
      expect(response.body).to include("01455 883 250")
    end

    it "shows the accreditation scheme email" do
      expect(response.body).to include("enquiries@elmhurstenergy.co.uk")
    end

    it "shows the assessors related party disclosure using code" do
      expect(response.body).to include("No related party")
    end

    it "shows the assessors telephone number" do
      expect(response.body).to include("12345678901")
    end

    it "shows the assessors email address" do
      expect(response.body).to include("test.boi@quidos.com")
    end

    it "does not show the warning to landlords that it cannot be rented out" do
      expect(response.body).not_to include(
        "You may not be able to let this property",
      )
    end

    it "does not show information about rules on letting F-G properties" do
      expect(response.body).not_to include(
        "If the property is rated F or G,",
      )
    end

    it "all ids are unique" do
      div_ids = Capybara.string(response.body).all("div").map { |d| d["id"] }.compact
      dd_ids = Capybara.string(response.body).all("dd").map { |d| d["id"] }.compact
      spans_ids = Capybara.string(response.body).all("span").map { |d| d["id"] }.compact
      ids = div_ids + dd_ids + spans_ids
      ids.each do |id|
        expect(response.body).to have_css("##{id}", count: 1)
      end
    end

    context "when a EER rating is F-G" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1119",
          current_rating: 25,
          current_band: "f",
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1119" }

      it "shows content informing the user they are not able to let the property" do
        expect(response.body).to include("It cannot be let, unless an exemption has been registered.")
        expect(response.body).to include("Properties can be let if they have an energy rating from A to E.")
      end
    end

    context "when a related party disclosure code is not included" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "shows related party disclosure text, not disclosure code translation" do
        expect(response.body).to include("Financial interest in the property")
      end
    end

    context "when a relate party disclosure code is not valid" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-1234",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: "7.8453",
          potential_carbon_emission: "6.5123",
          related_party_disclosure_number: 12,
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

      it "shows related party disclosure code is not valid" do
        expect(response.body).to include(
          "The disclosure code provided is not valid",
        )
      end
    end

    context "when a related party disclosure code and text are nil" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-1234",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: "7.8453",
          potential_carbon_emission: "6.5123",
          related_party_disclosure_text: nil,
          related_party_disclosure_number: nil,
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

      it "shows related party disclosure text and code not present" do
        expect(response.body).to include("No assessor’s declaration provided")
      end
    end

    context "when a related party disclosure code is nil and text is whitespace" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-1234",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: "7.8453",
          potential_carbon_emission: "6.5123",
          related_party_disclosure_text: "\n        ",
          related_party_disclosure_number: nil,
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

      it "shows related party disclosure text and code not present" do
        expect(response.body).to include("No assessor’s declaration provided")
      end
    end

    context "when there is no total floor area present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-1234",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: "7.8453",
          potential_carbon_emission: "6.5123",
          total_floor_area: "",
          postcode: "SW1B 2BB",
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

      it "shows not recorded next to the total floor area" do
        page = Nokogiri.XML(response.body)
        total_floor_area =
          page.css ":contains(\"Total floor area\"):not(:has(:contains(\"Total floor area\")))"

        expect(total_floor_area.first.parent.css("dd").first.content.strip).to eq "Not recorded"
      end
    end

    context "when the total floor area is 0" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-1234",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: "7.8453",
          potential_carbon_emission: "6.5123",
          total_floor_area: "0.0",
          postcode: "SW1B 2BB",
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

      it "shows not recorded next to the total floor area" do
        page = Nokogiri.XML(response.body)
        total_floor_area =
          page.css ":contains(\"Total floor area\"):not(:has(:contains(\"Total floor area\")))"

        expect(
          total_floor_area.first.parent.css("dd").first.content.strip,
        ).to eq "Not recorded"
      end
    end

    describe "viewing the how this affects your energy bills section" do
      context "when there is no information about estimated spending, heating, or insulation" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-1234-1234-1234-1234",
            estimated_energy_cost: nil,
            current_space_heating_demand: nil,
            current_water_heating_demand: nil,
            impact_of_loft_insulation: nil,
            impact_of_cavity_insulation: nil,
            impact_of_solid_wall_insulation: nil,
          )
        end

        let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

        it "does not show the entire section on how energy bills are affected" do
          expect(response.body).not_to have_css "h2",
                                                text:
                                                  "How this affects your energy bills"
        end

        it "does not show the link to the energy bill section in the certificate contents" do
          expect(response.body).not_to have_css "a",
                                                text:
                                                  "How this affects your energy bills"
        end
      end

      context "when there is no information about estimated spending" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-1234-1234-1234-1234",
            estimated_energy_cost: nil,
          )
        end

        let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

        it "does not show the information about the effect on bills" do
          expect(response.body).not_to have_css "p",
                                                text:
                                                  "An average household would need to spend"
        end
      end

      context "when one of the costs that make up the estimated energy cost is missing" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-1234-1234-1234-1234",
            hot_water_cost_current: "0.00",
          )
        end

        let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

        it "does not show the information about the effect on bills" do
          expect(response.body).not_to have_css "p",
                                                text:
                                                  "An average household would need to spend"
        end
      end

      context "when there is no information about the impact of heating" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-1234-1234-1234-1234",
            current_space_heating_demand: nil,
            current_water_heating_demand: nil,
          )
        end

        let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

        it "does not show the heating section" do
          expect(response.body).not_to have_css "h3",
                                                text:
                                                  "Heating this property"
        end
      end

      context "when there is no information about the impact of insulation" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-1234-1234-1234-1234",
            current_rating: 25,
            current_band: "f",
            current_carbon_emission: "7.8453",
            potential_carbon_emission: "6.5123",
            impact_of_loft_insulation: nil,
            impact_of_cavity_insulation: nil,
            impact_of_solid_wall_insulation: nil,
          )
        end

        let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

        it "does not show the insulation section" do
          expect(response.body).not_to have_css "h3",
                                                text:
                                                  "Saving energy by installing insulation"
        end
      end

      it "shows the section heading" do
        expect(response.body).to have_css "h2",
                                          text:
                                            "How this affects your energy bills"
      end

      it "shows the link to the energy bill section in the certificate contents" do
        expect(response.body).to have_css "a",
                                          text:
                                            "How this affects your energy bills"
      end

      it "shows the date the energy costs are based on" do
        expect(response.body).to include(
          'This is <span class="govuk-!-font-weight-bold">based on average costs in 2020</span>',
        )
      end

      it "shows the estimated energy cost for a year" do
        expect(response.body).to include(
          'An average household would need to spend <span class="govuk-!-font-weight-bold">£689.83 per year on heating, hot water and lighting</span> in this property.',
        )
      end

      it "shows the potential energy cost saving for a year" do
        expect(response.body).to include('You could <span class="govuk-!-font-weight-bold">save £174 per year</span> if you complete the suggested steps for improving this property’s energy rating.')
      end

      it "shows the current space heat demand" do
        expect(response.body).to include("222 kWh per year for heating")
      end

      it "shows the current water heat demand" do
        expect(response.body).to include("321 kWh per year for hot water")
      end
    end

    context "when viewing find advice and find ways to pay for recommendations section" do
      it "shows the heading" do
        expect(response.body).to have_css "h3",
                                          text: "Advice on making energy saving improvements"
      end

      it "shows the text" do
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href=" https://www.gov.uk/improve-energy-efficiency">Get detailed recommendations and cost estimates</a></p>',
        )
      end
    end

    describe "when viewing get help paying for improvements section" do
      it "doesn't show the section for assessments not in England or Wales" do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-5678-1234-5678-1234",
          country_name: "Scotland",
        )

        expect(response.body).not_to have_css "h3",
                                              text: "Advice on making energy saving improvements"
        expect(response.body).not_to have_css "h3",
                                              text: "Help paying for energy saving improvements"
      end

      context "when one or more bullet points present" do
        it "shows the heading" do
          expect(response.body).to have_css "h3",
                                            text: "Help paying for energy saving improvements"
        end
      end

      context "when no bullet points are present" do
        it "doesn't show the heading" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            main_heating_source: "heat pump",
            current_band: "b",
            country_name: "England",
          )
          expect(response.body).not_to have_css "h3",
                                                text: "Help paying for energy saving improvements"
        end
      end

      context "when the home upgrade link is relevant" do
        context "when the property does not have a gas boiler" do
          it "shows the home upgrade link for properties in England" do
            FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
              assessment_id: "1234-5678-1234-5678-1234",
              current_band: "d",
              country_name: "England",
            )
            expect(response.body).to have_css "a",
                                              text: "Home Upgrade Grant"
          end

          it "shows the home upgrade section for properties on the border" do
            FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
              assessment_id: "1234-5678-1234-5678-1234",
              current_band: "d",
              country_name: "England and Wales",
            )

            expect(response.body).to have_css "li",
                                              text: "Free energy saving improvements if you live in England:"
            expect(response.body).to have_css "a",
                                              text: "Home Upgrade Grant"
          end
        end
      end

      context "when the home upgrade link is not relevant" do
        it "doesn't show the home upgrade section for properties with gas boilers" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            main_heating_source: "boiler with radiators or underfloor heating",
            current_band: "d",
            country_name: "England",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Home Upgrade Grant"
        end

        it "doesn't show the home upgrade section for properties with an A-C rating" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "a",
            country_name: "England",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Home Upgrade Grant"
        end

        it "doesn't show the home upgrade section for properties in Wales" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "d",
            country_name: "Wales",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Home Upgrade Grant"
        end

        it "doesn't show the home upgrade section for properties in Northern Ireland" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "d",
            country_name: "Northern Ireland",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Home Upgrade Grant"
        end
      end

      context "when the insulation scheme is relevant" do
        it "shows the insulation scheme link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "e",
          )
          expect(response.body).to have_css "a",
                                            text: "Great British Insulation Scheme"
        end

        it "doesn't show the insulation scheme link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "b",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Great British Insulation Scheme"
        end
      end

      context "when the BUS scheme is relevant" do
        it "shows the BUS scheme link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            main_heating_source: "boiler with radiators or underfloor heating",
          )
          expect(response.body).to have_css "a",
                                            text: "Boiler Upgrade Scheme"
        end

        it "doesn't show the BUS scheme link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            main_heating_source: "heat pump",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Boiler Upgrade Scheme"
        end
      end

      context "when the Energy Company Obligation link is relevant" do
        it "shows the insulation scheme link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "e",
          )
          expect(response.body).to have_css "a",
                                            text: "Energy Company Obligation"
        end

        it "doesn't show the insulation scheme link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            current_band: "b",
          )

          expect(response.body).not_to have_css "a",
                                                text: "Energy Company Obligation"
        end
      end

      context "when the certificate is for an address in Wales" do
        it "shows the nest link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            country_name: "Wales",
          )
          expect(response.body).to have_css "a",
                                            text: "Speak to an advisor from Nest"
        end

        it "shows the nest improvements link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            country_name: "Wales",
            current_band: "d",
          )
          expect(response.body).to have_css "li",
                                            text: "Free energy saving improvements: "
          expect(response.body).to have_css "a",
                                            text: "Nest"
        end
      end

      context "when the certificate is for an address on the England and Wales border" do
        it "shows the nest link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            country_name: "England and Wales",
          )
          expect(response.body).to have_css "p",
                                            text: "If you live in Wales,"
          expect(response.body).to have_css "a",
                                            text: "speak to an advisor from Nest"
        end

        it "shows the nest improvements link" do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1234",
            country_name: "England and Wales",
            current_band: "d",
          )

          expect(response.body).to have_css "li",
                                            text: "Free energy saving improvements if you live in Wales:"
          expect(response.body).to have_css "a",
                                            text: "Nest"
        end
      end
    end

    context "when viewing environmental impact section" do
      it "shows the impact title" do
        expect(response.body).to include('<h2 class="govuk-heading-l">Impact on the environment</h2>')
      end

      it "shows the link to the environmental impact section in the certificate contents" do
        expect(response.body).to have_css "a",
                                          text:
                                            "Impact on the environment"
      end

      it "shows the summary text" do
        expect(response.body).to have_css "p",
                                          text: "This property’s environmental impact rating is C. It has the potential to be B."
      end

      it "shows the carbon emission section" do
        expect(response.body).to include('<h3 class="govuk-heading-m">Carbon emissions</h3>')
      end

      it "shows the making changes text with the correct reduction value" do
        expect(response.body).to include(
          "You could improve this property’s CO2 emissions by making the suggested changes. This will help to protect the environment.",
        )
      end

      it "shows the environmental impact rating text" do
        expect(response.body).to include(
          "These ratings are based on assumptions about average occupancy and energy use. People living at the property may use different amounts of energy.",
        )
      end

      it "shows the carbon emissions of the property" do
        expect(response.body).to include(">An average household produces</")
        expect(response.body).to include(">6 tonnes of CO2</dd>")
        expect(response.body).to include(">This property produces</")
        expect(response.body).to include(">2.4 tonnes of CO2</dd>")
        expect(response.body).to include(
          ">This property’s potential production</",
        )
        expect(response.body).to include(">1.4 tonnes of CO2</dd>")
      end

      context "with different carbon emissions" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-1234-1234-1234-6543",
            current_rating: 25,
            current_band: "f",
            current_carbon_emission: "7.8453",
            potential_carbon_emission: "6.5123",
          )
        end

        let(:response) { get "/energy-certificate/1234-1234-1234-1234-6543" }

        it "shows the making changes text" do
          expect(response.body).to include(
            "You could improve this property’s CO2 emissions by making the suggested changes. This will help to protect the environment.",
          )
        end

        it "shows the correct carbon emission values" do
          expect(response.body).to include(">7.8 tonnes of CO2</dd>")
          expect(response.body).to include(">6.5 tonnes of CO2</dd>")
        end
      end
    end

    context "with a poor (f) rating" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-6543",
          current_rating: 25,
          current_band: "f",
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-6543" }

      it "shows a warning text" do
        expect(response.body).to include(
          "You may not be able to let this property",
        )
      end
    end

    context "when property is in Northern Ireland" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-1234-1234-1234-1234",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: "7.8453",
          potential_carbon_emission: "6.5123",
          related_party_disclosure_number: 12,
          postcode: "BT1 2BB",
        )
      end

      let(:response) { get "/energy-certificate/1234-1234-1234-1234-1234" }

      it "shows a warning text" do
        expect(response.body).not_to include(
          "You may not be able to let this property",
        )
      end

      it "shows the average rating text" do
        expect(response.body).to have_css "p",
                                          text: "For properties in Northern Ireland:"
        expect(response.body).to have_css "li",
                                          text: "the average energy rating is D"
        expect(response.body).to have_css "li",
                                          text: "the average energy score is 60"
        expect(response.body).not_to have_css "p",
                                              text: "For properties in England and Wales:"
      end

      it "does not show the Simple Energy Advice text" do
        expect(response.body).not_to have_css "a",
                                              text:
                                                "Find ways to save energy in your home."
        expect(
          response.body,
        ).not_to have_link "Find ways to save energy in your home.",
                           href: "https://www.gov.uk/improve-energy-efficiency"
      end
    end

    context "when there were no recommendations made" do
      it "shows there aren’t any recommendations for this property text" do
        expect(response.body).to include(
          "The assessor did not make any recommendations for this property.",
        )
      end
    end

    context "when viewing the breakdown of property’s energy performance section" do
      it "shows the section title" do
        expect(response.body).to include(
          "<h2 class=\"govuk-heading-l\">Breakdown of property’s energy performance</h2>",
        )
      end

      it "shows the section texts" do
        expect(response.body).to include(
          '<p class="govuk-body">Features get a rating from very good to very poor, based on how energy efficient they are. Ratings are not based on how well features work or their condition.</p>',
        )
      end

      context "when there are no low and zero carbon energy sources" do
        it "does not show the LZC energy sources" do
          expect(response.body).not_to include(
            "Low and zero carbon energy sources",
          )
        end
      end

      context "when there is a low and zero carbon energy source on the property" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1111-1111-1111-1111-1112",
            lzc_energy_sources: [11],
          )
        end

        let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

        it "shows Low and zero carbon energy sources section and the details" do
          expect(response.body).to include(
            '<h3 class="govuk-heading-m">Low and zero carbon energy sources</h3>',
          )
          expect(response.body).to have_css "li", text: "Solar photovoltaics"
        end
      end

      it "shows the primary energy use section", :aggregate_failures do
        expect(response.body).to include('<h3 class="govuk-heading-m">Primary energy use</h3>')
        expect(response.body).to include('<p class="govuk-body">The primary energy use for this property per year is 989 kilowatt hours per square metre (kWh/m2).</p>')
        expect(response.body).to include('<span class="govuk-details__summary-text">About primary energy use</span>')
      end

      context "when there is a property summary key" do
        it "shows all of the property summary elements", :aggregate_failures do
          expect(response.body).to include("Wall")
          expect(response.body).to include("Many walls")
          expect(response.body).to include("Poor")
          expect(response.body).to include("Main heating")
          expect(response.body).to include("Room heaters, electric")
          expect(response.body).to include("Average")
        end

        describe "with no energy efficiency rating" do
          it "does show the element/feature" do
            expect(response.body).to have_css "th", text: "Roof"
            expect(response.body).to have_css "td",
                                              text: "(another dwelling above)"
            expect(response.body).to have_css "td", text: "N/A"
          end
        end
      end

      context "when the property summary key is empty" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1111-1111-1111-1111-1112",
          )
        end

        let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

        it "does not show the property summary elements", :aggregate_failures do
          expect(response.body).not_to include('<td class="govuk-table__cell">Secondary heating</td>')
          expect(response.body).not_to include('<td class="govuk-table__cell govuk-!-font-weight-bold">Very good</td>')
        end
      end

      context "when there is additional information" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1111-1111-1111-1111-1112",
            addendum: {
              addendumNumber: [4],
              stoneWalls: true,
            },
          )
        end

        let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

        it "shows Additional information section with all details", :aggregate_failures do
          expect(response.body).to include('<h3 class="govuk-heading-m">Additional information</h3>')
          expect(response.body).to have_css "li", text: "Dwelling has a swimming pool"
          expect(response.body).to include('<p class="govuk-hint">The energy assessment for the dwelling does not include energy used to heat the swimming pool.</p>')
          expect(response.body).to have_css "li", text: "Stone walls present, not insulated"
        end
      end

      context "when there is no additional information" do
        it "does not show Additional information section" do
          expect(response.body).not_to include(
            '<h2 class="govuk-heading-m">Additional information</h2>',
          )
        end
      end
    end

    context "when a certificate has a Green Deal Plan" do
      it "shows the green deal plan title when referrer is nil" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Green deal plan</h2>',
        )
      end

      it "shows the green deal plan title when referred from RRN search" do
        env "HTTP_REFERER", "http://example.com/find-a-certificate/search-by-reference-number"
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Green deal plan</h2>',
        )
      end

      it "does not show the green deal plan title when referred from postcode search" do
        env "HTTP_REFERER", "http://example.com/find-a-certificate/search-by-postcode"
        expect(response.body).not_to include(
          '<h2 class="govuk-heading-l">Green deal plan</h2>',
        )
      end

      it "does not show the green deal plan title when referred from street and town search" do
        env "HTTP_REFERER", "http://example.com/find-a-certificate/search-by-street-name-and-town"
        expect(response.body).not_to include(
          '<h2 class="govuk-heading-l">Green deal plan</h2>',
        )
      end

      it "shows the current charge" do
        expect(response.body).to include("Current charge")
        expect(response.body).to include("£124 per year")
      end

      it "shows the estimated savings" do
        expect(response.body).to include("Estimated saving")
        expect(response.body).to include("£1566 per year")
      end

      it "shows the start of the payment period" do
        expect(response.body).to include("Payment period start")
        expect(response.body).to include("30 January 2020")
      end

      it "shows the end of the payment period" do
        expect(response.body).to include("Payment period end")
        expect(response.body).to include("28 February 2030")
      end

      it "shows the interest rate payable" do
        expect(response.body).to include("Interest rate payable")
        expect(response.body).to include("fixed at 12.3% APR")
      end

      it "shows the product and paid off date" do
        expect(response.body).to include("WarmHome lagging stuff (TM)")
        expect(response.body).to include("Paid off 29 March 2025")
      end

      it "shows the plan number" do
        expect(response.body).to include("Plan number")
        expect(response.body).to include("ABC123456DEF")
      end

      it "shows the providers name" do
        expect(response.body).to include("Provider")
        expect(response.body).to include("The Bank")
      end

      it "shows the providers telephone number" do
        expect(response.body).to include("Telephone")
        expect(response.body).to include("0800 0000000")
      end

      it "shows the providers email" do
        expect(response.body).to include("Email")
        expect(response.body).to include(
          '<a class="govuk-link" href="mailto:lender@example.com">',
        )
      end

      context "without provider contact details" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1234-5678-1234-5678-1235",
            green_deal_plan: [
              {
                greenDealPlanId: "ABC123456DEF",
                startDate: "2020-01-30",
                endDate: "2030-02-28",
                providerDetails: {
                  name: "The Bank",
                },
                interest: {
                  rate: 12.3,
                  fixed: true,
                },
                chargeUplift: {
                  amount: 1.25,
                  date: "2025-03-29",
                },
                ccaRegulated: true,
                structureChanged: false,
                measuresRemoved: false,
                measures: [
                  {
                    sequence: 0,
                    measureType: "Loft insulation",
                    product: "WarmHome lagging stuff (TM)",
                    repaidDate: "2025-03-29",
                  },
                  {
                    sequence: 1,
                    measureType: "Double glazing",
                    product: "Not applicable",
                  },
                ],
                charges: [
                  {
                    sequence: 0,
                    startDate: "2020-03-29",
                    endDate: "2030-03-29",
                    dailyCharge: "0.33",
                  },
                  {
                    sequence: 1,
                    startDate: "2020-03-29",
                    endDate: "2030-03-29",
                    dailyCharge: "0.01",
                  },
                ],
                savings: [
                  {
                    fuelCode: "39",
                    fuelSaving: 23_253,
                    standingChargeFraction: 0,
                  },
                  {
                    fuelCode: "40",
                    fuelSaving: -6331,
                    standingChargeFraction: -0.9,
                  },
                  {
                    fuelCode: "41",
                    fuelSaving: -15_561,
                    standingChargeFraction: 0,
                  },
                ],
                estimatedSavings: 1566,
              },
            ],
          )
        end

        let(:response) { get "/energy-certificate/1234-5678-1234-5678-1235" }

        it "responds successfully" do
          expect(response.status).to eq 200
        end
      end
    end

    context "without provider contact details" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1234-5678-1234-5678-1235",
          green_deal_plan: [
            {
              greenDealPlanId: "ABC123456DEF",
              startDate: "2020-01-30",
              endDate: "2030-02-28",
              providerDetails: {
                name: "The Bank",
              },
              interest: {
                rate: 12.3,
                fixed: true,
              },
              chargeUplift: {
                amount: 1.25,
                date: "2025-03-29",
              },
              ccaRegulated: true,
              structureChanged: false,
              measuresRemoved: false,
              measures: [
                {
                  sequence: 0,
                  measureType: "Loft insulation",
                  product: "WarmHome lagging stuff (TM)",
                  repaidDate: nil,
                },
                {
                  sequence: 1,
                  measureType: "Double glazing",
                  product: "Not applicable",
                },
              ],
              charges: [
                {
                  sequence: 0,
                  startDate: "2020-03-29",
                  endDate: "2030-03-29",
                  dailyCharge: "0.33",
                },
                {
                  sequence: 1,
                  startDate: "2020-03-29",
                  endDate: "2030-03-29",
                  dailyCharge: "0.01",
                },
              ],
              savings: [
                {
                  fuelCode: "39",
                  fuelSaving: 23_253,
                  standingChargeFraction: 0,
                },
                {
                  fuelCode: "40",
                  fuelSaving: -6331,
                  standingChargeFraction: -0.9,
                },
                {
                  fuelCode: "41",
                  fuelSaving: -15_561,
                  standingChargeFraction: 0,
                },
              ],
              estimatedSavings: 1566,
            },
          ],
        )
      end

      let(:response) { get "/energy-certificate/1234-5678-1234-5678-1235" }

      it "shows the product but not any paid off date" do
        expect(response.body).to include("WarmHome lagging stuff (TM)")
        expect(response.body).not_to include("Paid off")
      end
    end

    context "when a certificate does not have a Green Deal Plan" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "does not show the Green Deal Plan section" do
        expect(response.body).not_to include(
          '<h2 class="govuk-heading-l">Green Deal Plan</h2>',
        )
      end

      it "does not show the Green Deal Plan section tab" do
        expect(response.body).not_to include(
          '<a class="govuk-link" href="#renting">Green Deal Plan</a>',
        )
      end
    end

    context "when viewing the related certificates section" do
      it "shows the section title" do
        expect(response.body).to have_css(
          "h2",
          text: "Other certificates for this property",
        )
      end

      it "shows contact details" do
        expect(response.body).to have_css(
          "p",
          text:
            "If you are aware of previous certificates for this property and they are not listed here, please contact us at mhclg.digital-services@communities.gov.uk or call our helpdesk on 020 3829 0748 (Monday to Friday, 9am to 5pm).",
        )
      end

      it "shows the related SAP and RdSAP certificates", :aggregate_failures do
        expect(response.body).to have_link "9025-0000-0000-0000-0000",
                                           href: "/energy-certificate/9025-0000-0000-0000-0000"
        expect(response.body).to have_link "9026-0000-0000-0000-0000",
                                           href: "/energy-certificate/9026-0000-0000-0000-0000"
      end

      context "when there are CANCELLED related certificates" do
        it "does not show cancelled related certificates" do
          expect(response.body).not_to have_css(
            "dd",
            text: "9024-0000-0000-0000-0000",
          )
        end
      end

      context "when there are no related certificates" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            assessment_id: "1111-1111-1111-1111-1112",
          )
        end

        let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

        it "Shows an appropriate message" do
          expect(response.body).to have_css(
            "p",
            text: "There are no related certificates for this property.",
          )
        end

        it "does not show the superseded warning message" do
          expect(response.body).not_to have_css("div.govuk-warning-text", text: " A new certificate has replaced this one. See the new certificate")
        end
      end
    end
  end

  context "when the assessment is fetched in Welsh" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
      )
    end

    let(:response) do
      get "/energy-certificate/1234-5678-1234-5678-1234?lang=cy"
    end

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "shows the related certificates section title capitalised" do
      expect(response.body).to have_css(
        "h2",
        text: "Tystysgrifau eraill ar gyfer yr eiddo hwn",
      )
    end

    it "shows the date in Welsh", :aggregate_failures do
      expect(response.body).to have_css "label", text: "Dilys tan"
      expect(response.body).to have_css("p", text: "5 Ionawr 2030")
    end

    it "shows the language toggle" do
      expect(response.body).to have_css "ul.language-toggle__list"
      expect(response.body).to have_link "English"
      expect(response.body).not_to have_link "Cymraeg"
    end
  end

  context "when the assessment exists with recommendations" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-1234-1234-1234-4567",
        recommended_improvements: true,
      )
    end

    let(:response) { get "/energy-certificate/1234-1234-1234-1234-4567" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "doesnt show there aren’t any recommendations for this property text" do
      expect(response.body).not_to include(
        "There aren’t any recommendations for this property.",
      )
    end

    it "shows recommendation title" do
      expect(response.body).to include(
        "Step 2: Double glazed windows",
      )
    end

    it "shows recommendation description when different from the title" do
      recommendation_title = Capybara.string(response.body).find("h3", text: "Step 2: Double glazed windows")
      expect(recommendation_title.find("+p").text).to include("Replace single glazed windows with low-E double glazed windows")
    end

    it "doesn't show recommendation description when description is the same as the title" do
      recommendation_title = Capybara.string(response.body).find("h3", text: "Step 4: Hot water cylinder thermostat")
      # If the description was shown, it would just be "Hot water cylinder thermostat" again
      expect { recommendation_title.find("+p") }.to raise_error Capybara::ElementNotFound
    end

    it "doesn't show recommendation description when description is a substring of the title" do
      recommendation_title = Capybara.string(response.body).find("h3", text: "Step 5: Solar photovoltaic panels, 2.5 kWp")
      # If the description was shown, it would just be "Solar photovoltaic panels" which adds no extra information to the title
      expect { recommendation_title.find("+p") }.to raise_error Capybara::ElementNotFound
    end

    it "shows recommendation description" do
      expect(response.body).to include(
        "Replace single glazed windows with low-E double glazed windows",
      )
    end

    it "shows typical indicativeCost" do
      expect(response.body).to include(">Typical installation cost</dt>")
      expect(response.body).to include("£300 - £400")
    end

    it "shows typicalSaving cost" do
      expect(response.body).to include(">Typical yearly saving</dt>")
      expect(response.body).to include("£9,000")
    end

    it "shows typical potential rating" do
      expect(response.body).to include(
        ">Potential rating after completing steps 1&nbsp;to&nbsp;11</dt>",
      )
      expect(response.body).to include('<text x="75" y="31" class="govuk-!-font-weight-bold">99 A</text>')
    end

    it "shows typical potential rating (second from end in recommendations list) in the correct color" do
      expect(Capybara.string(response.body).all("div.epb-recommended-improvements polygon")[-2]["class"]).to eq "band-c"
    end

    context "when the indicativeCost is empty" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
          recommended_improvements: true,
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "shows information unavailable instead" do
        expect(response.body).to include("Information unavailable")
      end
    end

    context "when the potential rating improvement is empty" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
          current_rating: 25,
          current_band: "f",
          current_carbon_emission: 7.8453,
          potential_carbon_emission: 6.5123,
          related_party_disclosure_number: 12,
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "shows information unavailable instead" do
        expect(response.body).to include("Not applicable")
      end
    end

    context "when the improvementCode is not present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
          recommended_improvements: true,
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "displays the improvementTitle and improvementDescription instead", :aggregate_failures do
        expect(response.body).to include("Step 1: Fix the boiler")
        expect(response.body).to include("An informative description of how to fix the boiler")
      end
    end
  end

  context "when the assessment exists with no recommendations" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-1234-1234-1234-7890",
        recommended_improvements: false,
      )
    end

    let(:response) { get "/energy-certificate/1234-1234-1234-1234-7890" }

    it "shows there aren’t any recommendations for this property text" do
      expect(response.body).to include(
        "The assessor did not make any recommendations for this property.",
      )
    end
  end

  context "when the assessment type is SAP" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_sap(
        assessment_id: "1234-5678-1234-5678-1234",
        current_rating: 90,
        current_band: "b",
        type_of_assessment: "SAP",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "displays the SAP type description" do
      expect(response.body).to include(
        "SAP (Standard Assessment Procedure) is a method used to assess and compare the energy and environmental performance of properties in the UK.",
      )
    end
  end

  context "when viewing a lodged certificate as returned from the API" do
    context "with an invalid typical saving" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "displays N/A on the page" do
        expect(response.body).to include("Not applicable")
      end
    end

    context "with an energy performance rating improvement given as 0" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1112",
          energy_performance_rating_improvement: 0,
        )
      end

      let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

      it "displays 'Information unavailable' on the page" do
        rating_node = Capybara.string(response.body).find("dt", text: "Potential rating after completing step 1", match: :prefer_exact).sibling("dd")
        expect(rating_node.text).to eq "Information unavailable"
      end
    end
  end

  context "when the assessment doesnt exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end

    it "does not display a back link" do
      expect(response.body).not_to include("Back")
    end
  end

  context "when the assessment id is malformed" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch_invalid_assessment_id(
        "1234-5678-5678-1234",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-5678-1234" }

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end

  context "when the assessment has been cancelled or marked not for issue" do
    before do
      FetchAssessmentSummary::GoneAssessmentStub.fetch(
        "1234-5678-1234-5678-1234",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "returns status 410" do
      expect(response.status).to eq(410)
    end

    it "shows the tag header that matches the page header" do
      expect(response.body).to include(
        "<title>This certificate has been cancelled – GOV.UK</title>",
      )
    end

    it "shows the error header" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">This certificate has been cancelled</h1>',
      )
    end

    it "shows the error page text" do
      expect(response.body).to have_css "p",
                                        text:
                                          "A new certificate may have replaced it. You can "
      expect(response.body).to have_css "a", text: "check if there is a new certificate"
    end
  end

  context "when the estimated or potential energy cost is missing" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1111-1111-1111-1111-1112",
      )
    end

    let(:response) { get "/energy-certificate/1111-1111-1111-1111-1112" }

    it "does not show the estimated energy cost for a year" do
      expect(response.body).not_to include(
        '<td class="govuk-table__cell" id="estimated-cost"></td>',
      )
    end

    it "does not show the potential energy cost saving for a year" do
      expect(response.body).not_to include(
        '<td class="govuk-table__cell" id="potential-saving"></td>',
      )
    end
  end

  context "when the certificate has been superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "shows the superseded warning message" do
      expect(response.body).to have_css("div.govuk-warning-text", text: /Warning/)
      expect(response.body).to have_css("div.govuk-warning-text", text: /A new certificate has replaced this one/)
    end

    it "the warning is hidden for print using the existing css definition" do
      expect(response.body).to include('<div class="govuk-warning-text"')
    end

    it "shows the superseded link" do
      expect(response.body).to have_link("See the new certificate", href: "/energy-certificate/9025-0000-0000-0000-0000")
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

    let(:response) { get "/energy-certificate/1111-1111-1111-1111-1119" }

    it "shows the expired on message in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box label", text: "This certificate expired on")
    end

    it "shows the expired date in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box p", text: "5 January 2010")
    end

    it "shows an expired warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "This certificate has expired.")
    end

    it "shows a link to get the get service within the warning message" do
      expect(response.body).to have_css(".govuk-warning-text a")
      expect(response.body).to have_link("get a new certificate", href: "http://getting-new-energy-certificate.local.gov.uk:9393/")
    end

    context "when the expired epc has been superseded" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "1111-1111-1111-1111-1119",
          expiry_date: "2010-01-05",
        )
      end

      it "shows an superseded warning message" do
        expect(response.body).to have_css(".govuk-warning-text", text: "A new certificate has replaced this one")
      end

      it "does not show an expired warning message" do
        expect(response.body).not_to have_css(".govuk-warning-text", text: "This certificate has expired")
      end
    end
  end

  context "when the API request for the certificate summary times out" do
    before do
      FetchAssessmentSummary::TimeoutAssessmentFetchStub.fetch(assessment_id: "0000-1111-2222-3333-4444")
    end

    let(:response) { get "/energy-certificate/0000-1111-2222-3333-4444" }

    it "returns a 504 response" do
      expect(response.status).to eq 504
    end
  end
end
