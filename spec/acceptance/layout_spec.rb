# frozen_string_literal: true

describe "Acceptance::AccessibilityStatement", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate" do
    context "when the home page is rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/"
      end

      it "contains a footer link to the accessibility statement" do
        expect(response.body).to include(
          '<a class="govuk-footer__link" href="/accessibility-statement">',
        )
      end
    end
  end
end
