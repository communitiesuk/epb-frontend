# frozen_string_literal: true

describe "Acceptance::DecRecommendationReport", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/1234-5678-1234-5678-1234"
  end

  context "when the assessment does not exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    it "returns status 404" do
      expect(response.status).to eq 404
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end

  context "when the assessment exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec_rr(
        assessment_id: "1234-5678-1234-5678-1234", date_of_expiry: "2030-01-01",
      )
    end

    it "shows the page title" do
      expect(response.body).to include(
        "Display Energy Certificate Recommendation Report (DEC-RR)",
      )
    end

    it "shows the top summary box" do
      expect(response.body).to include("1 Lonely Street")
      expect(response.body).to include("Post-Town0")
      expect(response.body).to include("A0 0AA")
      expect(response.body).to include("1234-5678-1234-5678-1234")
      expect(response.body).to include("1 January 2030")
    end

    it "shows the rating section" do
      expect(response.body).to have_css "h2", text: "Energy rating and DEC"
      expect(response.body).to have_css "p",
                                        text: "This building has an energy rating of A."
      expect(response.body).to have_css "p",
                                        text: "See the Display Energy Certificate for this building."
      expect(
        response.body,
      ).to have_link "Display Energy Certificate for this building",
                     href: "/energy-performance-certificate/0000-0000-0000-0000-1111"
    end

    it "shows the Recommendations section" do
      expect(response.body).to have_css "h2", text: "Recommendations"
      expect(response.body).to have_css "p",
                                        text:
                                          "The assessment found opportunities to improve the building’s energy efficiency."
      expect(response.body).to have_css "p",
                                        text:
                                          "Recommended improvements are grouped by the estimated time it would take for the change to pay for itself. The assessor may also make additional recommendations."
      expect(response.body).to have_css "p",
                                        text:
                                          "Each recommendation is marked as low, medium or high for the potential impact the change would have on reducing the building’s carbon emissions."
      expect(response.body).to have_css "th", text: "Recommendation"
      expect(response.body).to have_css "th", text: "Potential impact"
      expect(response.body).to have_css "caption",
                                        text: "Changes that pay for themselves within 3 years"
      expect(response.body).to have_css "th",
                                        text:
                                          "Consider thinking about maybe possibly getting a solar panel but only one."
      expect(response.body).to have_css "td", text: "Medium"
      expect(response.body).to have_css "th",
                                        text:
                                          "Consider introducing variable speed drives (VSD) for fans, pumps and compressors."
      expect(response.body).to have_css "td", text: "Low"
      expect(response.body).to have_css "caption",
                                        text: "Changes that pay for themselves within 3 to 7 years"
      expect(response.body).to have_css "th",
                                        text:
                                          "Engage experts to propose specific measures to reduce hot waterwastage and plan to carry this out."
      expect(response.body).to have_css "td", text: "Low"
      expect(response.body).to have_css "caption",
                                        text: "Changes that pay for themselves in more than 7 years"
      expect(response.body).to have_css "th",
                                        text: "Consider replacing or improving glazing."
      expect(response.body).to have_css "td", text: "Low"
      expect(response.body).to have_css "caption",
                                        text: "Additional recommendations"
      expect(response.body).to have_css "th", text: "Add a big wind turbine."
      expect(response.body).to have_css "td", text: "High"
    end

    it "shows the Building and report details section" do
      expect(response.body).to have_css "h2",
                                        text: "Building and report details"
      expect(response.body).to have_css "dt", text: "Building occupier"
      expect(response.body).to have_css "dd", text: "City Council"
      expect(response.body).to have_css "dt", text: "Building type"
      expect(response.body).to have_css "dd", text: "University campus"
      expect(response.body).to have_css "dt", text: "Building environment"
      expect(response.body).to have_css "dd",
                                        text: "Heating and natural ventilation"
      expect(response.body).to have_css "dt",
                                        text: "On-site renewable energy sources"
      expect(response.body).to have_css "dd", text: "Renewable energy source"
      expect(response.body).to have_css "dt",
                                        text: "Separable energy uses discounted"
      expect(response.body).to have_css "dd", text: "Separable energy use"
      expect(response.body).to have_css "dt", text: "Electricity used"
      expect(response.body).to have_css "dd", text: "751445 kW h"
      expect(response.body).to have_css "dt", text: "Gas used"
      expect(response.body).to have_css "dd", text: "72956 kW h"
      expect(response.body).to have_css "dt", text: "Total useful floor area"
      expect(response.body).to have_css "dd", text: "935 square metres"
      expect(response.body).to have_css "dt", text: "Building reference"
      expect(response.body).to have_css "dd", text: "90806560123"
      expect(response.body).to have_css "dt", text: "Report issued on"
      expect(response.body).to have_css "dd", text: "22 September 2010"
      expect(response.body).to have_css "dt", text: "Calculation tool"
      expect(response.body).to have_css "dd", text: "DCLG, ORCalc, v3.6.2"
      expect(response.body).to have_css "dt", text: "Type of inspection"
      expect(response.body).to have_css "dd", text: "Physical"
    end

    it "shows the Assessor’s details section" do
      expect(response.body).to have_css "h2", text: "Assessor’s details"
      expect(response.body).to have_css "dt", text: "Assessor’s name"
      expect(response.body).to have_css "dd", text: "John Howard"
      expect(response.body).to have_css "dt", text: "Employer’s name"
      expect(response.body).to have_css "dd", text: "Joe Bloggs Ltd"
    end
  end
end
