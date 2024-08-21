describe "Acceptance::HelpPage", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".find getting-new-energy-certificate/help" do
    context "when help page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/help"
      end

      it "displays the help page title" do
        expect(response.body).to have_title "Get help finding an energy certificate – GOV.UK"
      end

      it "displays the help page heading" do
        expect(response.body).to have_css "h1", text: "Get help finding an energy certificate"
      end

      it "displays the intro" do
        expect(response.body).to have_css "p.govuk-body", text: "If you need help finding an energy certificate or report, contact the Ministry of Housing, Communities and Local Government (MHCLG)."
      end

      it "displays the tel" do
        expect(response.body).to have_css "div.govuk-body", text: "Telephone: 020 3829 0748"
      end

      it "displays the email" do
        expect(response.body).to have_link "mhclg.digital-services@communities.gov.uk", href: "mailto:mhclg.digital-services@communities.gov.uk"
      end

      it "displays the opening hours" do
        expect(response.body).to have_css "div.govuk-body", text: "Monday to Friday, 9am to 5pm"
      end

      it "has a link to the found out more" do
        expect(response.body).to have_link("Find out more about call charges", href: "https://www.gov.uk/call-charges")
      end
    end
  end

  describe ".get getting-new-energy-certificate/help" do
    context "when help page rendered" do
      let(:response) do
        get "http://fgetting-new-energy-certificate.local.gov.uk/help"
      end

      it "displays the help page title" do
        expect(response.body).to have_title "Get help finding an energy assessor – GOV.UK"
      end

      it "displays the help page heading" do
        expect(response.body).to have_css "h1", text: "Get help finding an energy assessor"
      end

      it "displays the intro" do
        expect(response.body).to have_css "p.govuk-body", text: "For help finding an assessor, contact the Ministry of Housing, Communities and Local Government (MHCLG)."
      end
    end
  end
end
