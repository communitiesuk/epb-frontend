# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificateRecommendationReport",
         type: :feature do
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
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: nil,
        related_energy_band: "d",
      )
    end

    it "Shows the page title" do
      expect(response.body).to include(
        "Non-domestic Energy Performance Certificate Recommendation Report",
      )
    end

    it "Shows the top summary box" do
      expect(response.body).to include("1 Lonely Street")
      expect(response.body).to include("Post-Town0")
      expect(response.body).to include("A0 0AA")
      expect(response.body).to include("1234-5678-1234-5678-1234")
      expect(response.body).to include("1 January 2030")
    end

    it "Shows the efficiency band from the related cepc" do
      expect(response.body).to include(
        "This building’s current energy rating is D.",
      )
    end

    it "Shows a link to the related CEPC" do
      expect(response.body).to include("/0000-0000-0000-0000-0000")
    end

    it "Shows the recommendations" do
      expect(response.body).to include(
        "Consider replacing T8 lamps with retrofit T5 conversion kit.",
      )
      expect(response.body).to include(
        "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
      )
      expect(response.body).to include(
        "Add optimum start/stop to the heating system.",
      )
      expect(response.body).to include(
        "Consider installing an air source heat pump.",
      )
      expect(response.body).to include("Consider installing PV.")
      expect(response.body).to include("High")
      expect(response.body).to include("Medium")
      expect(response.body).to include("Low")
    end

    it "Shows the building and report details" do
      expect(response.body).to include("4 May 2020")
      expect(response.body).to include("10 square metres")
      expect(response.body).to include("Natural Ventilation Only")
      expect(response.body).to include("Calculation-Tool0")
    end

    it "Shows the assessor details" do
      expect(response.body).to include("Mrs Report Writer")
      expect(response.body).to include("SPEC000000")
      expect(response.body).to include("Quidos")
      expect(response.body).to include("Joe Bloggs Ltd")
      expect(response.body).to include("123 My Street, My City, AB3 4CD")
    end

    it "Shows the related party disclosure" do
      expect(response.body).to include(
        "The assessor has not indicated whether they have a relation to this property",
      )
    end

    it "shows the Other reports for this property" do
      expect(response.body).to have_css "h2",
                                        text: "Other CEPC-RRs for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous reports for this property and they are not listed here, please contact the Help Desk at 01632 164 6672."
      expect(response.body).to have_css "dt", text: "Reference number"
      expect(response.body).to have_link "9457-0000-0000-0000-2000",
                                         href: "/energy-performance-certificate/9457-0000-0000-0000-2000"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).not_to have_link "0000-0000-0000-0000-5555",
                                             href: "/energy-performance-certificate/0000-0000-0000-0000-5555"
    end
  end

  context "with a related party disclosure" do
    it "shows the the related party disclosure text" do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234", related_party: "some text",
      )

      response = get "/energy-performance-certificate/1234-5678-1234-5678-1234"

      expect(response.body).to have_css "dd.govuk-summary-list__value",
                                        text: "some text"
    end
  end

  context "when there are no related assessments" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: "Connected to owner",
        related_energy_band: "d",
        related_assessments: [],
      )
    end

    it "shows the no related reports text" do
      expect(response.body).to have_css "p", text: "There are no related reports for this property."
    end
  end

  context "when there are no company details" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        company_details: { name: nil, address: nil },
      )
    end

    it "does not show the employer details" do
      expect(response.body).not_to include("Joe Bloggs Ltd")
      expect(response.body).not_to include("123 My Street, My City, AB3 4CD")
    end
  end

  context "when there is no information about the related CEPC" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-9999",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: "Connected to owner",
        related_energy_band: nil,
      )
    end

    it "doesnt show the related cepc section" do
      page_without_cepc =
        get "/energy-performance-certificate/1234-5678-1234-5678-9999"
      expect(page_without_cepc.body).to_not include("Energy rating and EPC")
    end
  end
end
