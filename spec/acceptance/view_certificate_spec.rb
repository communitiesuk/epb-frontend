# frozen_string_literal: true

describe "Acceptance::EnergyPerformanceCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

  context "when an energy certificate exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
        assessment_id: "1234-5678-1234-5678-1234",
        )
    end

    it "has cache control headers set to 60 seconds" do
      expect(response.headers['Cache-Control']).to eq("public, max-age=60")
    end
  end

  context "when an energy certificate does not exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch(assessment_id: "1234-5678-1234-5678-1234")
    end

    it "has no cache control header set" do
      expect(response.headers['Cache-Control']).to be nil
    end
  end
end
