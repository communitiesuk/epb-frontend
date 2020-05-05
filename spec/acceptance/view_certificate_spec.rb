# frozen_string_literal: true

describe "Acceptance::Certificate" do
  include RSpecFrontendServiceMixin

  context "when the assessment exists" do
    before { FetchCertificate::Stub.fetch("123-456") }

    let(:response) { get "/energy-performance-certificate/123-456" }

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
      expect(response.body).to include("123-456")
    end

    it "shows the date of assessment" do
      expect(response.body).to include("05 January 2020")
    end

    it "shows the registered date of the certificate" do
      expect(response.body).to include("02 January 2020")
    end

    it "shows the date of expiry" do
      expect(response.body).to include("05 01 2030")
    end

    it "shows the type of assessment" do
      expect(response.body).to include("RdSAP")
    end

    it 'shows the total floor area' do
      expect(response.body).to include(
        '<dd class="govuk-summary-list__value govuk-!-font-weight-bold" name="total-floor-area">150 m<sup>2</sup></dd>'
      )
    end

    it "shows the type of dwelling" do
      expect(response.body).to include("Top floor flat")
    end

    it "shows the SVG with energy ratings" do
      expect(response.body).to include('<svg width="615" height="376"')
    end

    it "shows the assessors full name" do
      expect(response.body).to include("Test Boi")
    end

    it "shows the assessors accreditation scheme" do
      expect(response.body).to include("Quidos")
    end

    it "shows the assessors accreditation number" do
      expect(response.body).to include("TESTASSESSOR")
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

    it 'shows the current space heat demand' do
      expect(response.body).to include(
        '<span name="space-heat-demand">222<span>kWh per year</span></span>'
      )
    end

    it 'shows the current water heat demand' do
      expect(response.body).to include(
        '<span name="water-heating-demand">321<span>kWh per year</span></span>'
      )
    end

    it 'shows possible energy saving with loft insulation' do
      expect(response.body).to include(
        '<td class="govuk-table__cell" name="loft-insulation">79</td>'
      )
    end

    it 'shows possible energy saving with cavity insulation' do
      expect(response.body).to include(
        '<td class="govuk-table__cell" name="cavity-insulation">67</td>'
      )
    end

    it 'shows possible energy saving with solid wall insulation' do
      expect(response.body).to include(
        '<td class="govuk-table__cell" name="solid-wall-insulation">69</td>'
      )
    end

    context "when viewing Find ways to pay for recommendations section" do
      it "shows the heading" do
        expect(response.body).to include("Paying for energy improvements")
      end

      it "shows the text" do
        expect(response.body).to include("Find energy grants and ways to save energy in your home.")
      end

      it "shows the link" do
        expect(response.body).to include("https://www.gov.uk/improve-energy-efficiency")
      end
    end

    context "when viewing environmental impact section" do
      it "shows the summary text" do
        expect(response.body).to include(
          "The energy used for heating, lighting and power in our homes produces over a quarter of the UK's CO<sub>2</sub> emissions.",
        )
      end

      it "shows the making changes text with the correct reduction value" do
        expect(response.body).to include(
          "By making the recommended changes, you will reduce this property’s carbon emissions by 1.0 tonnes per year",
        )
      end

      it "shows the environmental impact rating text" do
        expect(response.body).to include(
          "Environmental impact ratings are based on assumptions about average occupancy and energy use.",
        )
      end

      it 'shows the carbon emissions of the property' do
        expect(response.body).to include('Average household produces')
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value" name="average-household-produces">6 tonnes of CO<sub>2</sub></dd>'
        )
        expect(response.body).to include('This property produces')
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value" name="property-produces">2.4 tonnes of CO<sub>2</sub></dd>'
        )
        expect(response.body).to include("This property's potential production")
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value" name="potential-production">1.4 tonnes of CO<sub>2</sub></dd>'
        )
      end

      context "with different carbon emissions" do
        before do
          FetchCertificate::Stub.fetch(
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
            "By making the recommended changes, you will reduce this property’s carbon emissions by 1.33 tonnes per year",
          )
        end

        it "shows the correct carbon emission values" do
          expect(response.body).to include(
            '<dd class="govuk-summary-list__value" name="property-produces">7.8 tonnes of CO<sub>2</sub></dd>'
          )
          expect(response.body).to include(
            '<dd class="govuk-summary-list__value" name="potential-production">6.5 tonnes of CO<sub>2</sub></dd>'
          )
        end
      end
    end

    context "with a poor (f) rating" do
      before { FetchCertificate::Stub.fetch("123-654", "25", "f") }

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
  end

  context "when the assessment exists with recommendations" do
    before { FetchCertificate::Stub.fetch("122-456", 90, "b", true) }

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

    it 'shows typicalSaving cost' do
      expect(response.body).to include(
        '<p class="govuk-body govuk-!-font-weight-bold" name="typical-saving-cost">£9,000</p>'
      )
    end

    it 'shows typical indicativeCost' do
      expect(response.body).to include(
        '<p class="govuk-body govuk-!-font-weight-bold" name="indicative_cost">£300 - £400</p>'
      )
    end

    context "when the indicativeCost is empty" do
      before do
        FetchCertificate::Stub.fetch("1111-1111-1111-1111-1112", 90, "b", true)
      end
      let(:response) do
        get "/energy-performance-certificate/1111-1111-1111-1111-1112"
      end

      it "will show information unavailable instead" do
        expect(response.body).to include("Information unavailable")
      end
    end

    context "when the improvementCode is not present" do
      before do
        FetchCertificate::Stub.fetch("1111-1111-1111-1111-1112", 90, "b", true)
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

  context "when viewing a lodged certificate as returned from the API" do
    before { FetchCertificate::Stub.fetch("1111-1111-1111-1111-1112") }

    let(:response) do
      get "/energy-performance-certificate/1111-1111-1111-1111-1112"
    end

    context "with an invalid typical saving" do
      it 'displays N/A on the page' do
        expect(response.body).to include(
          '<p class="govuk-body govuk-!-font-weight-bold" name="typical-saving-cost">Not applicable</p>'
        )
      end
    end
  end

  context "when the assessment doesnt exist" do
    before { FetchCertificate::NoAssessmentStub.fetch("123-456") }

    let(:response) { get "/energy-performance-certificate/123-456" }

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end
end
