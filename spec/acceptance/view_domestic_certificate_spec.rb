# frozen_string_literal: true

describe "Acceptance::DomesticEnergyPerformanceCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  context "when the assessment exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        "1234-5678-1234-5678-1234",
      )
    end

    let(:response) do
      get "/energy-performance-certificate/1234-5678-1234-5678-1234"
    end

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "shows the EPC title" do
      expect(response.body).to include("Energy Performance Certificate")
    end

    it "shows the address summary" do
      expect(response.body).to include("2 Marsham Street")
      expect(response.body).to include("London")
      expect(response.body).to include("SW1B 2BB")
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
      expect(response.body).to include(
        '<span class="govuk-details__summary-text">RdSAP</span>',
      )
    end

    it "shows the type of assessment description" do
      expect(response.body).to include(
        "RdSAP (Reduced data Standard Assessment Procedure) is a method used to assess and compare the energy and environmental performance of properties in the UK",
      )
    end

    it "shows the total floor area" do
      expect(response.body).to include(
        "has a total floor area of 150 square metres",
      )
    end

    it "shows the type of dwelling" do
      expect(response.body).to include("This property is a Top floor flat")
    end

    it "shows the SVG with energy ratings" do
      expect(response.body).to include('<svg width="615" height="376"')
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

    it "does not shows the warning to landlords that it cannot be rented out" do
      expect(response.body).to_not include(
        "The owner of this property may not be able to let it",
      )
    end

    context "When a related party disclosure code is not included" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "1111-1111-1111-1111-1112",
        )
      end

      let(:response) do
        get "/energy-performance-certificate/1111-1111-1111-1111-1112"
      end

      it "shows related party disclosure text, not disclosure code translation" do
        expect(response.body).to include("Financial interest in the property")
      end
    end

    context "When a relate party disclosure code is not valid" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "123-123",
          "25",
          "f",
          false,
          7.8453,
          6.5123,
          nil,
          nil,
          nil,
          nil,
          12,
        )
      end

      let(:response) { get "/energy-performance-certificate/123-123" }

      it "shows related party disclosure code is not valid" do
        expect(response.body).to include(
          "The disclosure code provided is not valid",
        )
      end
    end

    context "When a related party disclosure code and text are nil" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "123-123",
          "25",
          "f",
          false,
          7.8453,
          6.5123,
          nil,
          nil,
          nil,
          nil,
          nil,
        )
      end

      let(:response) { get "/energy-performance-certificate/123-123" }

      it "shows related party disclosure text and code not present" do
        expect(response.body).to include("No related party disclosure provided")
      end
    end

    describe "viewing the estimated energy use and potential savings section" do
      context "when there is no information about the impact of insulation" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            "123-123",
            "25",
            "f",
            false,
            7.8453,
            6.5123,
            nil,
            nil,
            nil,
          )
        end

        let(:response) { get "/energy-performance-certificate/123-123" }

        it "does not show the potential space heating energy savings table" do
          expect(response.body).not_to include(">Loft insulation</")
          expect(response.body).not_to include(">Cavity wall insulation</")
          expect(response.body).not_to include(">Solid wall insulation</")
        end
      end

      it "shows the section heading" do
        expect(response.body).to include(
          ">Estimated energy use and potential savings</h2>",
        )
      end

      it "shows the estimated energy cost for a year" do
        expect(response.body).to include(
          "Estimated energy cost for this property over a year",
        )
        expect(response.body).to include("&pound;689.83")
      end

      it "shows the potential energy cost saving for a year" do
        expect(response.body).to include("Over a year you could save")
        expect(response.body).to include("&pound;174")
      end

      it "shows the current space heat demand" do
        expect(response.body).to include(">Space heating</")
        expect(response.body).to include("222 kWh per year")
      end

      it "shows the current water heat demand" do
        expect(response.body).to include(">Water heating</")
        expect(response.body).to include("321 kWh per year")
      end

      it "shows possible energy saving with loft insulation" do
        expect(response.body).to include(">Loft insulation</th>")
        expect(response.body).to include(">79 kWh per year</td>")
      end

      it "shows possible energy saving with cavity wall insulation" do
        expect(response.body).to include(">Cavity wall insulation</th>")
        expect(response.body).to include(">67 kWh per year</td>")
      end

      it "shows possible energy saving with solid wall insulation" do
        expect(response.body).to include(">Solid wall insulation</th>")
        expect(response.body).to include(">69 kWh per year</td>")
      end
    end

    context "when viewing find ways to pay for recommendations section" do
      it "shows the heading" do
        expect(response.body).to include("Paying for energy improvements")
      end

      it "shows the text" do
        expect(response.body).to include(
          "Find energy grants and ways to save energy in your home.",
        )
      end

      it "shows the link" do
        expect(response.body).to include(
          "https://www.gov.uk/improve-energy-efficiency",
        )
      end
    end

    context "when viewing environmental impact section" do
      it "shows the summary text" do
        expect(response.body).to include(
          "The energy used for heating, lighting and power in our homes produces over a quarter of the UK's CO2 emissions.",
        )
      end

      it "shows the making changes text with the correct reduction value" do
        expect(response.body).to include(
          'By making the <a href="#recommendations">recommended changes</a>, you will reduce this property’s CO2 emissions by 1.0 tonnes per year.',
        )
      end

      it "shows the environmental impact rating text" do
        expect(response.body).to include(
          "Environmental impact ratings are based on assumptions about average occupancy and energy use.",
        )
      end

      it "shows the carbon emissions of the property" do
        expect(response.body).to include(">Average household produces</")
        expect(response.body).to include(">6 tonnes of CO2</dd>")
        expect(response.body).to include(">This property produces</")
        expect(response.body).to include(">2.4 tonnes of CO2</dd>")
        expect(response.body).to include(
          ">This property's potential production</",
        )
        expect(response.body).to include(">1.4 tonnes of CO2</dd>")
      end

      context "with different carbon emissions" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            "123-654",
            "25",
            "f",
            false,
            7.8453,
            6.5123,
          )
        end

        let(:response) { get "/energy-performance-certificate/123-654" }

        it "shows the making changes text with the correct reduction value" do
          expect(response.body).to include(
            'By making the <a href="#recommendations">recommended changes</a>, you will reduce this property’s CO2 emissions by 1.33 tonnes per year.',
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
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap("123-654", "25", "f")
      end

      let(:response) { get "/energy-performance-certificate/123-654" }
      it "shows a warning text" do
        expect(response.body).to include(
          "You may not be able to let this property",
        )
      end
    end

    context "when there were no recommendations made" do
      it "shows there aren’t any recommendations for this property text" do
        expect(response.body).to include(
          "There are no recommendations for this property.",
        )
      end
    end

    context "when viewing the breakdown of property's energy performance section" do
      it "shows the section title" do
        expect(response.body).to include(
          "<h2 class=\"govuk-heading-l\">Breakdown of property's energy performance</h2>",
        )
      end

      it "shows the section texts" do
        expect(response.body).to include(
          '<p class="govuk-body">This section shows the energy performance for features of this property. The assessment does not consider the condition of a feature and how well it is working.</p>',
        )
      end

      it "shows the primary energy use section" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-m">Primary energy use</h2>',
        )
        expect(response.body).to include(
          '<p class="govuk-body">The primary energy use for this property per year is 989 kilowatt hours (kWh) per square metre</p>',
        )
        expect(response.body).to include(
          '<span class="govuk-details__summary-text">What is primary energy use?</span>',
        )
      end

      context "when there is a property summary key" do
        it "shows all of the property summary elements" do
          expect(response.body).to include("Wall")
          expect(response.body).to include("Many walls")
          expect(response.body).to include("Poor")
          expect(response.body).to include("Main Heating")
          expect(response.body).to include("Room heaters, electric")
          expect(response.body).to include("Average")
        end

        describe "with no energy efficiency rating" do
          it "does not show the element/feature" do
            expect(response.body).not_to include("Roof")
            expect(response.body).not_to include("(another dwelling above)")
          end
        end
      end

      context "when the property summary key is empty" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            "1111-1111-1111-1111-1112",
          )
        end

        let(:response) do
          get "/energy-performance-certificate/1111-1111-1111-1111-1112"
        end

        it "will not show the property summary elements" do
          expect(response.body).not_to include(
            '<td class="govuk-table__cell">Secondary heating</td>',
          )
          expect(response.body).not_to include(
            '<td class="govuk-table__cell govuk-!-font-weight-bold">Very good</td>',
          )
        end
      end
    end

    context "when a certificate has a Green Deal Plan" do
      it "shows the green deal plan title" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Green Deal Plan</h2>',
        )
      end

      it "shows the current charge" do
        expect(response.body).to include("Current charge")
        expect(response.body).to include("£124.18 per year")
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
        expect(response.body).to include('<a href="mailto:lender@example.com">')
      end

      context "but there are no provider contact details" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
            "1234-5678-1234-5678-1235",
            90,
            "b",
            false,
            2.4,
            1.4,
            -79,
            -67,
            -69,
            nil,
            1,
            nil,
            "RdSAP",
            76,
            {
              greenDealPlanId: "ABC123456DEF",
              startDate: "2020-01-30",
              endDate: "2030-02-28",
              providerDetails: { name: "The Bank" },
              interest: { rate: 12.3, fixed: true },
              chargeUplift: { amount: 1.25, date: "2025-03-29" },
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
                  fuelCode: "39", fuelSaving: 23_253, standingChargeFraction: 0
                },
                {
                  fuelCode: "40",
                  fuelSaving: -6331,
                  standingChargeFraction: -0.9,
                },
                {
                  fuelCode: "41", fuelSaving: -15_561, standingChargeFraction: 0
                },
              ],
              estimatedSavings: 1566,
            },
            nil,
            nil,
          )
        end

        let(:response) do
          get "/energy-performance-certificate/1234-5678-1234-5678-1235"
        end

        it "responds successfully" do
          expect(response.status).to eq 200
        end

        it "does not show the provider email" do
          expect(response.body).not_to include(
            "<dt class=\"govuk-summary-list__key govuk-!-width-one-half\">Email</dt>",
          )
        end
      end
    end

    context "when a certificate does not have a Green Deal Plan" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "1111-1111-1111-1111-1112",
        )
      end

      let(:response) do
        get "/energy-performance-certificate/1111-1111-1111-1111-1112"
      end

      it "does not show the Green Deal Plan section" do
        expect(response.body).to_not include(
          '<h2 class="govuk-heading-l">Green Deal Plan</h2>',
        )
      end

      it "does not show the Green Deal Plan section tab" do
        expect(response.body).to_not include(
          '<a href="#renting">Green Deal Plan</a>',
        )
      end
    end

    context "when viewing the related certificates section" do
      it "shows the section title" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Other EPCs for this property</h2>',
        )
      end

      it "shows a link to the reference number of a related certificate" do
        expect(response.body).to include(
          '<a href="/energy-performance-certificate/0000-0000-0000-0000-0001">0000-0000-0000-0000-0001</a>',
        )
      end

      it "shows the expiry date of a previous certificate in red with Expired next to it" do
        expect(response.body).to include("1 July 2002 (Expired)")
      end

      context "when there are no related certificates" do
        before { FetchCertificate::Stub.fetch "1111-1111-1111-1111-1112" }

        let(:response) do
          get "/energy-performance-certificate/1111-1111-1111-1111-1112"
        end

        it "does not show the section title" do
          expect(response.body).not_to include(
            '<h2 class="govuk-heading-l">Other certificates for this property</h2>',
          )
        end
      end
    end
  end

  context "when the assessment exists with recommendations" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        "122-456",
        90,
        "b",
        true,
      )
    end

    let(:response) { get "/energy-performance-certificate/122-456" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end
    it "shows making any of the recommended changes will improve your property’s energy efficiency text" do
      expect(response.body).to include(
        "Making any of the recommended changes will improve your property’s energy efficiency.",
      )
    end

    it "doesnt show there aren’t any recommendations for this property text" do
      expect(response.body).not_to include(
        "There aren’t any recommendations for this property.",
      )
    end

    it "shows recommendation title" do
      expect(response.body).to include(
        "Recommendation 2: Double glazed windows",
      )
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
        ">Potential rating after carrying out recommendations 1&nbsp;to&nbsp;11</dt>",
      )
      expect(response.body).to include('<text x="30" y="30">99 | A</text>')
    end

    it "shows typical potential rating in the correct color" do
      expect(response.body).to include(
        '<rect width="75" height="50" class=band-c x="25"></rect>',
      )
    end

    context "when the indicativeCost is empty" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "1111-1111-1111-1111-1112",
          90,
          "b",
          true,
        )
      end
      let(:response) do
        get "/energy-performance-certificate/1111-1111-1111-1111-1112"
      end

      it "will show information unavailable instead" do
        expect(response.body).to include("Information unavailable")
      end
    end

    context "when the potential rating improvement  is empty" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "1111-1111-1111-1111-1112",
          "25",
          "f",
          false,
          7.8453,
          6.5123,
          nil,
          nil,
          nil,
          nil,
          12,
          nil,
          nil,
          nil,
        )
      end
      let(:response) do
        get "/energy-performance-certificate/1111-1111-1111-1111-1112"
      end

      it "will show information unavailable instead" do
        expect(response.body).to include("Not applicable")
      end
    end

    context "when the improvementCode is not present" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "1111-1111-1111-1111-1112",
          90,
          "b",
          true,
        )
      end
      let(:response) do
        get "/energy-performance-certificate/1111-1111-1111-1111-1112"
      end

      it "displays the improvementTitle and improvementDescription instead" do
        expect(response.body).to include("Fix the boiler")
        expect(response.body).to include(
          "An informative description of how to fix the boiler",
        )
      end
    end
  end

  context "when the assessment type is SAP" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_sap(
        "1234-5678-1234-5678-1234",
        90,
        "b",
        true,
        2.4,
        1.4,
        79,
        67,
        69,
        nil,
        1,
        nil,
        "SAP",
      )
    end
    let(:response) do
      get "/energy-performance-certificate/1234-5678-1234-5678-1234"
    end

    it "displays the SAP type description" do
      expect(response.body).to include(
        "SAP (Standard Assessment Procedure) is a method used to assess and compare the energy and environmental performance of properties in the UK.",
      )
    end
  end

  context "when viewing a lodged certificate as returned from the API" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        "1111-1111-1111-1111-1112",
      )
    end

    let(:response) do
      get "/energy-performance-certificate/1111-1111-1111-1111-1112"
    end

    context "with an invalid typical saving" do
      it "displays N/A on the page" do
        expect(response.body).to include("Not applicable")
      end
    end
  end

  context "when the assessment doesnt exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    let(:response) do
      get "/energy-performance-certificate/1234-5678-1234-5678-1234"
    end

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

    let(:response) do
      get "/energy-performance-certificate/1234-5678-1234-5678-1234"
    end

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end

  context "when the estimated or potentail energy cost is missing" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        "1111-1111-1111-1111-1112",
      )
    end

    let(:response) do
      get "/energy-performance-certificate/1111-1111-1111-1111-1112"
    end

    it "does not show the estimated energy cost for a year" do
      expect(response.body).to_not include(
        '<td class="govuk-table__cell" id="estimated-cost"></td>',
      )
    end

    it "does not show the potential energy cost saving for a year" do
      expect(response.body).to_not include(
        '<td class="govuk-table__cell" id="potential-saving"></td>',
      )
    end
  end
end
