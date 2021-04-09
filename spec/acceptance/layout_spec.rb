# frozen_string_literal: true

describe "Acceptance::AccessibilityStatement", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate" do
    context "when the home page is rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/"
      end

      it "tab value is the same as the main header value" do
        expect(response.body).to include(
          "<title>Getting a new energy certificate – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "contains a footer link to the accessibility statement" do
        expect(response.body).to include(
          '<a class="govuk-footer__link" href="/accessibility-statement">',
        )
      end

      it "contains a footer link to the cookies page" do
        expect(response.body).to include(
          '<a class="govuk-footer__link" href="/cookies">',
        )
      end

      it "includes the gov header " do
        expect(response.body).to have_link "Getting an energy certificate"
      end
    end
  end

  describe ".get find-energy-certificate.epb-frontend" do
    context "when the home page is rendered" do
      let(:response) { get "http://find-energy-certificate.local.gov.uk/" }

      it "tab value is the same as the main header value" do
        expect(response.body).to include(
          "<title>Find an energy certificate – Find an energy certificate – GOV.UK</title>",
        )
      end

      it "includes the gov header " do
        expect(response.body).to have_link "Find an energy certificate"
      end
    end
  end
end
