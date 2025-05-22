# frozen_string_literal: true

describe "Acceptance::AccessibilityStatement", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate" do
    context "when the home page is rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/"
      end

      context "when environment is production" do
        before { stub_const("ENV", { "STAGE" => "production" }) }

        it "doesn't have a banner in production" do
          page = get "http://getting-new-energy-certificate.local.gov.uk/"

          expect(page.body).not_to have_css("div .govuk-phase-banner")
        end
      end

      it "has a banner in non-production environment" do
        expect(response.body).to have_css("div .govuk-phase-banner", text: "This is a test site. The data is not real and the certificates are not valid.")
      end

      it "tab value is the same as the main header value" do
        expect(response.body).to include(
          "<title>Get a new energy certificate – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "has a footer" do
        expect(response.body).to have_css("footer")
      end

      it "has five links in the footer" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li", count: 5)
      end

      it "has a link in the footer for the help page" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(1) a", text: "Help")
        expect(response.body).to have_link("Help", href: "/help")
      end

      it "has a link in the footer for the accessibility statement" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(2) a", text: "Accessibility")
        expect(response.body).to have_link("Accessibility", href: "/accessibility-statement")
      end

      it "has a link in the footer for the cookies page" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(3) a", text: "Cookies")
        expect(response.body).to have_link("Cookies", href: "/cookies")
      end

      it "has a link in the footer for the feedback form" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(4) a", text: "Give feedback")
        expect(response.body).to have_link("Give feedback", href: "https://forms.office.com/e/KX25htGMX5")
      end

      it "has a link in the footer for the service performance" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(5) a", text: "Service performance")
        expect(response.body).to have_link("Service performance", href: "/service-performance")
      end

      it "includes the gov service navigation" do
        expect(response.body).to have_link "Get a new energy certificate"
      end

      it "does not allow indexing or following by crawlers" do
        expect(response.body).to include("<meta name=\"robots\" content=\"noindex, nofollow\">")
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

      it "includes the gov service navigation" do
        expect(response.body).to have_link "Find an energy certificate"
      end

      it "does not allow indexing or following by crawlers" do
        expect(response.body).to include("<meta name=\"robots\" content=\"noindex, nofollow\">")
      end
    end
  end

  describe "non start pages" do
    let(:response) { get "http://find-energy-certificate.local.gov.uk/find-a-certificate/type-of-property" }

    it "does not allow indexing or following by crawlers" do
      expect(response.body).to include("<meta name=\"robots\" content=\"noindex, nofollow\">")
    end
  end
end
