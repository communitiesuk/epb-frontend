# frozen_string_literal: true

describe "Acceptance::DisplayEnergyCertificate" do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub
          .fetch_dec("0000-0000-0000-0000-1111",
                     "2030-02-29")
    end

    it "Shows the page title" do
      expect(response.body).to include("Display Energy Certificate")
    end
  end
end
