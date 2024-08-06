# frozen_string_literal: true

require_relative "./content_security_policy_behaviour"

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
      expect(response.headers["Cache-Control"]).to eq("public, max-age=60")
    end

    it_behaves_like "all script elements have nonce attributes"
    it_behaves_like "all style elements have nonce attributes"
  end

  context "when an energy certificate does not exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    it "has no cache control header set" do
      expect(response.headers["Cache-Control"]).to be_nil
    end
  end
end
