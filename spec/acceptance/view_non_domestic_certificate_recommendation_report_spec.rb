# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificateRecommendationReport" do
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
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr("1234-5678-1234-5678-1234")
    end

    it "Shows the page title" do
      expect(response.body).to include("Non-domestic Energy Performance Certificate Recommendation Report")
    end

    it "Shows the top summary box" do
      expect(response.body).to include("1 Lonely Street")
      expect(response.body).to include("Post-Town0")
      expect(response.body).to include("A0 0AA")
      expect(response.body).to include("1234-5678-1234-5678-1234")
      expect(response.body).to include("1 January 2030")
    end
  end
end
