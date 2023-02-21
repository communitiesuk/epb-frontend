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

          expect(page.body).not_to have_css("div .govuk-phase-banner", text: "This is a non-production environment")
        end
      end

      it "has a banner in non-production environment" do
        expect(response.body).to have_css("div .govuk-phase-banner", text: "This is a non-production environment")
      end

      it "tab value is the same as the main header value" do
        expect(response.body).to include(
          "<title>Get a new energy certificate – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "has a footer" do
        expect(response.body).to have_css("footer")
      end

      it "has four links in the footer" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li", count: 4)
      end

      it "has a link in the footer for the accessibility statement" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(1) a", text: "Accessibility statement")
        expect(response.body).to have_link("Accessibility statement", href: "/accessibility-statement")
      end

      it "has a link in the footer for the cookies page" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(2) a", text: "Cookies on our service")
        expect(response.body).to have_link("Cookies on our service", href: "/cookies")
      end

      it "has a link in the footer for the feedback form" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(3) a", text: "Give feedback")
        expect(response.body).to have_link("Give feedback", href: "https://forms.office.com/e/hUnC3Xq1T4")
      end

      it "has a link in the footer for the service performance" do
        expect(response.body).to have_css("footer ul.govuk-footer__inline-list li:nth-child(4) a", text: "Service performance")
        expect(response.body).to have_link("Service performance", href: "/service-performance")
      end

      it "includes the gov header" do
        expect(response.body).to have_link "Get a new energy certificate"
      end

      it "allows indexing the start page by Google Search but does not allow to follow the links" do
        expect(response.body).to include("<meta name=\"robots\" content=\"nofollow\">")
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

      it "includes the gov header" do
        expect(response.body).to have_link "Find an energy certificate"
      end

      it "allows indexing the start page by Google Search but does not allow to follow the links" do
        expect(response.body).to include("<meta name=\"robots\" content=\"nofollow\">")
      end
    end
  end

  describe "non start pages" do
    let(:response) { get "http://find-energy-certificate.local.gov.uk/find-a-certificate/type-of-property" }

    it "does not allow indexing and following by Google Search" do
      expect(response.body).to include("<meta name=\"robots\" content=\"noindex, nofollow\">")
    end
  end
end
