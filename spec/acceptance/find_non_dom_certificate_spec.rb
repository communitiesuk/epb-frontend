# frozen_string_literal: true

describe "Acceptance::Non Domestic Certificate" do
  include RSpecFrontendServiceMixin

  describe ".get find-energy-certificate/find-a-non-domestic-certificate/search-by-postcode",
           type: :feature do
    context "when search page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode"
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "Find energy certificates and reports by postcode"
      end

      it "has an input field" do
        expect(response.body).to have_css "input#postcode"
      end

      it "has a Find button" do
        expect(response.body).to have_css "button", text: "Find"
      end

      it "does not display an error message" do
        expect(response.body).not_to have_text "govuk-error-message"
      end

      it "has a link to search by certificate number" do
        expect(
          response.body,
        ).to have_link "find a certificate by using its certificate number",
                       href:
                         "/find-a-non-domestic-certificate/search-by-reference-number"
      end
    end

    context "when entering an empty postcode" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a certificate page heading" do
        expect(response.body).to include("Find energy certificates and reports")
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a real postcode")
      end
    end

    context "when entering a postcode that is over 10 characters" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=++SW1A+2AA7A8++"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a certificate page heading" do
        expect(response.body).to include("Find energy certificates and reports")
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a real postcode")
      end
    end

    context "when entering a postcode that is less than 4 characters" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=WHA"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a certificate page heading" do
        expect(response.body).to include("Find energy certificates and reports")
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a real postcode")
      end
    end

    context "when entering a valid postcode" do
      context "with surrounding whitespaces" do
        before { FindCertificate::Stub.search_by_postcode("SW1A 2AA", "CEPC") }

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=++SW1A+2AA++"
        end

        it "returns status 200" do
          expect(response.status).to eq 200
        end
      end

      context "shows page" do
        before { FindCertificate::Stub.search_by_postcode("SW1A 2AA", "CEPC") }

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=SW1A+2AA"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the find a non-domestic certificate results page heading" do
          expect(response.body).to include(
            "Find energy certificates and reports",
          )
        end

        it "shows the information regarding getting a new EPC" do
          expect(response.body).to include(
            "If your property does not have a valid EPC, you can",
          )
        end

        it "show the text for the getting a new energy certificate link" do
          expect(response.body).to have_css "a",
                                            text: "get a new energy certificate"
        end

        it "shows the address of an entry" do
          expect(response.body).to include("2 Marsham Street, London, SW1B 2BB")
        end

        it "shows the report certificate number of an entry" do
          expect(response.body).to include("1234-5678-9101-1122-1234")
        end

        it "shows the report type of an entry" do
          expect(response.body).to include(">CEPC<")
        end

        it "shows a clickable entry" do
          expect(response.body).to include(
            '<a class="govuk-link" href="/energy-certificate/1234-5678-9101-1122-1234"',
          )
        end

        it "shows the expiry date of an entry" do
          expect(response.body).to include("1 January 2030")
        end
      end

      context "where no certificates are present" do
        before do
          FindCertificate::NoCertificatesStub.search_by_postcode(
            "E1 4FF",
            "CEPC",
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=E1+4FF"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "Find energy certificates and reports",
          )
        end

        it "dynamically shows that there are no certificates for that postcode" do
          expect(response.body).to include("No results for E1 4FF")
        end

        it "explains that no certificates or reports are present" do
          expect(response.body).to include(
            "There are no certificates for this postcode.",
          )
        end

        it "shows the options to search again" do
          expect(response.body).to include("You can search again by:")
          expect(response.body).to have_css "a", text: "postcode"
          expect(response.body).to have_css "a", text: "street and town"
          expect(response.body).to have_css "a", text: "certificate number"
        end

        it "shows the information regarding getting a new cert or report" do
          expect(response.body).to include(
            "If your property does not have an EPC, you can",
          )
        end

        it "shows the text for the getting a new energy certificate or report link" do
          expect(response.body).to have_css "a",
                                            text: "get a new energy certificate"
        end
      end

      context "when there is no connection" do
        before { FindCertificate::NoNetworkStub.search_by_postcode("D11 4FF") }

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=D11+4FF"
        end

        it "returns status 500" do
          expect(response.status).to eq(500)
        end

        it "displays the 500 error page heading" do
          expect(response.body).to include("Try again later.")
        end

        it "displays error page body" do
          expect(response.body).to include(
            "Sorry, there is a problem with the service",
          )
        end
      end
    end
  end

  describe ".get getting-new-energy-certificate/find-a-non-domestic-certificate/search-by-street-name-and-town",
           type: :feature do
    context "when search page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town"
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end

      it "has a tab content that matches the page heading" do
        expect(response.body).to include(
          " <title>Find an energy performance certificate (EPC) by street and town - Find an energy certificate - GOV.UK</title>\n",
        )
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text:
                                            "Find an energy performance certificate (EPC) by street and town"
      end

      it "has two input fields" do
        expect(response.body).to have_css "input#street_name"
        expect(response.body).to have_css "input#town"
      end

      it "has a Find button" do
        expect(response.body).to have_css "button", text: "Find"
      end

      it "does not display an error message" do
        expect(response.body).not_to have_text "govuk-error-message"
      end
    end

    context "when entering a valid street name and town" do
      context "shows page" do
        before do
          FindCertificate::Stub.search_by_street_name_and_town(
            "1 Makeup Street",
            "Beauty Town",
            %w[AC-CERT AC-REPORT DEC DEC-RR CEPC CEPC-RR],
            "CEPC",
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=1%20Makeup%20Street&town=Beauty%20Town"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "Find energy certificates and reports",
          )
        end

        it "displays the text if user does not have a valid EPC" do
          expect(response.body).to include(
            "If your property does not have a valid EPC, you can",
          )
        end

        it "displays the link to getting a new EPC" do
          expect(response.body).to have_css(
            "a",
            text: "get a new energy certificate",
          )
        end

        it "shows the address of an entry" do
          expect(response.body).to include(
            "1 Makeup Street, Beauty Town, SW1B 2BB",
          )
        end

        it "shows the report certificate number of an entry" do
          expect(response.body).to include("1234-5678-9101-1121-3141")
        end

        it "shows the certificate type" do
          expect(response.body).to include("CEPC")
        end

        it "shows a clickable entry" do
          expect(response.body).to include(
            '<a class="govuk-link" href="/energy-certificate/1234-5678-9101-1121-3141"',
          )
        end

        it "shows the expiry date of an entry" do
          expect(response.body).to include("1 January 2019")
        end
      end

      context "where no certificates are present" do
        before do
          FindCertificate::NoCertificatesStub.search_by_street_name_and_town(
            "3 Alien Street",
            "Mars",
            %w[AC-CERT AC-REPORT DEC DEC-RR CEPC CEPC-RR],
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=3%20Alien%20Street&town=Mars"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "has a tab content that matches the page heading" do
          expect(response.body).to include(
            "<title>Find an energy performance certificate (EPC) by street and town - Find an energy certificate - GOV.UK</title>\n",
          )
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "Find an energy performance certificate (EPC) by street and town",
          )
        end

        it "explains that no certificates are present" do
          expect(response.body).to include(
            "A certificate was not found at this address",
          )
        end

        it "displays the text if user does not have an EPC" do
          expect(response.body).to include(
            "If your property does not have an EPC, you can",
          )
        end

        it "displays the link to getting a new EPC" do
          expect(response.body).to have_css(
            "a",
            text: "get a new energy certificate",
          )
        end
      end

      context "when there is no connection" do
        before do
          FindCertificate::NoNetworkStub.search_by_street_name_and_town(
            "Doesnt Matter",
            "Nothing",
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-certificate/search-by-street-name-and-town?street_name=Doesnt%20Matter&town=Nothing"
        end

        it "returns status 500" do
          expect(response.status).to eq(500)
        end

        it "displays the 500 error page heading" do
          expect(response.body).to include("Try again later.")
        end

        it "displays error page body" do
          expect(response.body).to include(
            "Sorry, there is a problem with the service",
          )
        end
      end
    end
  end

  describe ".get find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number",
           type: :feature do
    context "when search page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number"
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "Find energy certificates and reports by their number"
      end

      it "displays the find a non-domestic certificate page tab content" do
        expect(response.body).to include(
          "<title>Find energy certificates and reports by their number – Find an energy certificate – GOV.UK</title>",
        )
      end

      it "has an input field" do
        expect(response.body).to have_css "input#reference_number"
      end

      it "has a Find button" do
        expect(response.body).to have_css "button", text: "Find"
      end

      it "does not display an error message" do
        expect(response.body).not_to have_text "govuk-error-message"
      end
    end

    context "when entering an empty certificate number" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number?reference_number="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to include(
          "Find energy certificates and reports by their number",
        )
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<span id="reference-number-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a 20-digit certificate number")
      end

      it "displays an error in the title" do
        expect(response.body).to include(
          "<title>Error: Find energy certificates and reports by their number – Find an energy certificate – GOV.UK</title>",
        )
      end
    end

    context "when entering a valid certificate number" do
      context "that exists in the register" do
        before do
          FindCertificate::Stub.search_by_id("1234-5678-9101-1121-3141", "CEPC")
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number?reference_number=1234-5678-9101-1121-3141"
        end

        it "returns status 303" do
          expect(response.status).to eq(303)
        end

        it "redirects to the URL to view the requested certificate" do
          expect(response.location).to end_with(
            "/energy-certificate/1234-5678-9101-1121-3141",
          )
        end

        context "when viewing the page in welsh" do
          let(:response) do
            get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number?lang=cy&reference_number=1234-5678-9101-1121-3141"
          end

          it "returns status 303" do
            expect(response.status).to eq(303)
          end

          it "redirects to the URL to view the requested certificate" do
            expect(response.location).to end_with(
              "/energy-certificate/1234-5678-9101-1121-3141?lang=cy",
            )
          end
        end
      end

      context "where no certificates are present" do
        before do
          FindCertificate::NoCertificatesStub.search_by_id(
            "1234-5678-9101-1120-1234",
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number?reference_number=1234-5678-9101-1120-1234"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "Find energy certificates and reports by their number",
          )
        end

        it "explains that no certificates are present" do
          expect(response.body).to include(
            "A certificate was not found with this certificate number",
          )
        end

        it "displays an error in the title" do
          expect(response.body).to include(
            "<title>Error: Find energy certificates and reports by their number – Find an energy certificate – GOV.UK</title>",
          )
        end
      end

      context "when there is no connection" do
        before do
          FindCertificate::NoNetworkStub.search_by_id(
            "1234-5678-9101-1122-1234",
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number?reference_number=1234-5678-9101-1122-1234"
        end

        it "returns status 500" do
          expect(response.status).to eq(500)
        end

        it "displays the 500 error page heading" do
          expect(response.body).to include("Try again later.")
        end

        it "displays error page body" do
          expect(response.body).to include(
            "Sorry, there is a problem with the service",
          )
        end
      end
    end
  end
end
