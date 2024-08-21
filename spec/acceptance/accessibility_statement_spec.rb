# frozen_string_literal: true

describe "Acceptance::AccessibilityStatement", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate/accessibility-statement" do
    context "when accessibility statement page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/accessibility-statement"
      end

      it "displays the accessibility statement page heading" do
        expect(response.body).to include("Accessibility statement")
      end

      it "displays the accessibility statement contents" do
        expect(response.body).to include(
          "The Ministry of Housing, Communities and Local Government is committed to making its website accessible",
        )
      end
    end
  end

  describe ".get find-energy-certificate/accessibility-statement" do
    context "when accessibility statement page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/accessibility-statement"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the accessibility statement page heading" do
        expect(response.body).to include("Accessibility statement")
      end

      it "displays the accessibility statement contents" do
        expect(response.body).to include(
          "The content listed below is non-accessible for the following reasons.",
        )
      end
    end
  end
end
