# frozen_string_literal: true

describe "Acceptance::DisplayEnergyCertificate" do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111"
  end

  context "when a dec exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_dec(
        "0000-0000-0000-0000-1111",
        "2030-02-21",
      )
    end

    it "shows the page title" do
      expect(response.body).to include("Display Energy Certificate")
    end

    it "shows the summary box" do
      expect(response.body).to include("0000-0000-0000-0000-1111")
      expect(response.body).to include("Valid until 21 February 2030")
      expect(response.body).to include("A")
      expect(response.body).to include("2 Lonely Street")
      expect(response.body).to include("Post-Town1")
      expect(response.body).to include("A0 0AA")
    end

    it "shows the rating section" do
      expect(response.body).to include(
        ">Energy performance of this building</h2>",
      )
      expect(response.body).to include(
        'The building’s energy performance is based on its carbon dioxide (CO2) emissions for the last year.',
      )
      expect(response.body).to include('It is given a score and an energy rating on a scale from A (lowest emissions) to G (highest emissions).',)
      expect(response.body).to include(
        'Typical energy performance for a public building is 100. This typical score gives an energy rating of D.',
      )
      expect(response.body).to include(">1 | A</text>")
      expect(response.body).to include(
        'You can read <a href="https://www.gov.uk/government/publications/display-energy-certificates-and-advisory-reports-for-public-buildings">guidance on Display Energy Certificates and advisory reports for public buildings</a>.',
      )
    end
  end
end
