# frozen_string_literal: true

describe "Acceptance::PrintableDisplayEnergyCertificate", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111?print=true"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        assessment_id: "0000-0000-0000-0000-1111", date_of_expiry: "2030-02-21",
      )
    end

    it "shows the page title" do
      expect(
        response.body,
      ).to have_text "Display Energy Certificate - how energy efficient is this building?"
    end
  end
end
