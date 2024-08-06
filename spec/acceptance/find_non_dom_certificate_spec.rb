# frozen_string_literal: true

describe "Acceptance::NonDomesticCertificate" do
  include RSpecFrontendServiceMixin

  describe ".get find-energy-certificate/find-a-non-domestic-certificate/search-by-postcode",
           type: :feature do
    context "when search page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode"
      end

      it "has the correct page title" do
        expect(response.body).to have_title "What is the postcode? – Find an energy certificate – GOV.UK"
      end

      it "includes the gov header" do
        expect(response.body).to have_link "Find an energy certificate"
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "What is the postcode?"
      end

      it "has an input field" do
        expect(response.body).to have_css "input#postcode"
      end

      it "has an label for the postcode" do
        expect(response.body).to have_css 'label[for="postcode"]', text: "Enter the postcode"
      end

      it "has a Find button" do
        expect(response.body).to have_css "button", text: "Find"
      end

      it "has a link to find the postcode if you don't know it" do
        expect(response.body).to include(
          '<a class="govuk-link" href="https://www.royalmail.com/find-a-postcode">find a postcode on Royal Mail’s postcode finder</a>',
        )
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

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "What is the postcode?"
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<p id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a full UK postcode in the format LS1 4AP")
      end

      it "contains the required GDS error summary" do
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                      text: "There is a problem"
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                      text: "Enter a full UK postcode in the format LS1 4AP"
        expect(response.body).to have_link "Enter a full UK postcode in the format LS1 4AP",
                                           href: "#postcode"
        expect(response.body).to have_css "#postcode"
      end
    end

    context "when entering a postcode that is over 10 characters" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=++SW1A+2AA7A8++"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "What is the postcode?"
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<p id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a valid UK postcode in the format LS1 4AP")
      end

      it "contains the required GDS error summary" do
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                      text: "There is a problem"
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                      text: "Enter a valid UK postcode in the format LS1 4AP"
        expect(response.body).to have_link "Enter a valid UK postcode in the format LS1 4AP",
                                           href: "#postcode"
        expect(response.body).to have_css "#postcode"
      end
    end

    context "when entering a postcode that is less than 4 characters" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=WHA"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "What is the postcode?"
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<p id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a full UK postcode in the format LS1 4AP")
      end

      it "contains the required GDS error summary" do
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                      text: "There is a problem"
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                      text: "Enter a full UK postcode in the format LS1 4AP"
        expect(response.body).to have_link "Enter a full UK postcode in the format LS1 4AP",
                                           href: "#postcode"
        expect(response.body).to have_css "#postcode"
      end
    end

    context "when entering a postcode as an array" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode[]=E39GG"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
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

      context "when showing the page" do
        before { FindCertificate::Stub.search_by_postcode("SW1A 2AA", "CEPC") }

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-postcode?postcode=SW1A+2AA"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "has a correct page title" do
          expect(response.body).to include(
            "<title>2 certificates and reports for SW1A 2AA – Find an energy certificate – GOV.UK</title>",
          )
        end

        it "displays the find a non-domestic certificate results page heading" do
          expect(response.body).to include(
            "2 certificates and reports for SW1A 2AA",
          )
        end

        it "explains only properties with EPCs are listed" do
          expect(response.body).to include(
            "We only list properties with EPCs.",
          )
        end

        it "shows the information regarding getting a new EPC" do
          expect(response.body).to include(
            "If your address is not listed or your EPC has expired",
          )
        end

        it "show the text for the Get a new energy certificate link" do
          expect(response.body).to have_css "a",
                                            text: "get a new energy certificate"
        end

        it "shows the address of an entry" do
          expect(response.body).to include("2 Marsham Street, London, SW1A 2AA")
        end

        it "shows the report certificate number of an entry" do
          expect(response.body).to include("1234-5678-9101-1122-5678")
        end

        it "shows the report type of an entry" do
          expect(response.body).to include("CEPC")
        end

        it "includes visually hidden information" do
          expect(response.body).to include("<span class=\"govuk-visually-hidden\">for 2 Marsham Street, London, SW1A 2AA</span>")
        end

        it "shows a clickable entry" do
          expect(response.body).to include(
            '<a class="govuk-link" rel="nofollow" href="/energy-certificate/1234-5678-9101-1122-5678"',
          )
        end

        it "shows the expiry date of an entry" do
          expect(response.body).to include("1 January 2030")
        end
      end

      context "with no certificates present" do
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

        it "has a correct page title" do
          expect(response.body).to include(
            "<title>No results for E1 4FF – Find an energy certificate – GOV.UK</title>",
          )
        end

        it "dynamically shows the title that there are no certificates for that postcode" do
          expect(response.body).to include("No results for E1 4FF")
        end

        it "explains that no certificates or reports are present" do
          expect(response.body).to include(
            "We only list properties with EPCs. There are no results for this postcode.",
          )
        end

        it "shows the options to search again" do
          expect(response.body).to include("You can search again by:")
          expect(response.body).to have_css("span", class: "govuk-visually-hidden", text: "Search again using a")
          expect(response.body).to have_css "a", text: "postcode"
          expect(response.body).to have_css "a", text: "street and town"
          expect(response.body).to have_css "a", text: "certificate number"
        end

        it "shows the information regarding getting a new cert or report" do
          expect(response.body).to include(
            "If your property does not have an EPC, you can",
          )
        end

        it "shows the text for the Get a new energy certificate or report link" do
          expect(response.body).to have_css "a",
                                            text: "get a new energy certificate"
        end
      end

      context "when there is no connection" do
        before { FindCertificate::NoNetworkStub.search_by_postcode("D11 4FF", assessment_types: %w[AC-CERT AC-REPORT CEPC CEPC-RR DEC DEC-RR]) }

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

      it "includes the gov header" do
        expect(response.body).to have_link "Find an energy certificate"
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end

      it "has a title that matches the page heading" do
        expect(response.body).to include(
          "<title>What is the address? – Find an energy certificate – GOV.UK</title>\n",
        )
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text:
                                            "What is the address?"
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
      context "with a street and town that have associated certificates" do
        before do
          FindCertificate::Stub.search_by_street_name_and_town_one_result(
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

        it "displays the title" do
          expect(response.body).to include(
            "<title>1 certificates and reports for 1 Makeup Street Beauty Town – Find an energy certificate – GOV.UK</title>",
          )
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to have_css("h1", text: "1 certificates and reports for 1 Makeup Street Beauty Town")
        end

        it "explains only properties with EPCs are listed" do
          expect(response.body).to have_css("p", text: "We only list properties with EPCs.")
        end

        it "displays the text if user does not have a valid EPC" do
          expect(response.body).to include(
            "If your address is not listed or your EPC has expired",
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
          expect(response.body).to include("1234-5678-9101-1123-1234")
        end

        it "shows the certificate type" do
          expect(response.body).to include("CEPC")
        end

        it "shows a clickable entry" do
          expect(response.body).to include(
            '<a class="govuk-link" rel="nofollow" href="/energy-certificate/1234-5678-9101-1123-1234"',
          )
        end

        it "shows the expiry date of an entry" do
          expect(response.body).to include("1 January 2032")
        end
      end

      context "when missing the street name" do
        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=&town=Brighton"
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        it "has an error title" do
          expect(response.body).to include(
            "<title>Error: What is the address? – Find an energy certificate – GOV.UK</title>\n",
          )
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "What is the address",
          )
        end

        it "displays an error message" do
          expect(response.body).to include(
            '<p id="street_name-error" class="govuk-error-message">',
          )
          expect(response.body).to include("Enter the street name")
        end

        it "contains the required GDS error summary" do
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                        text: "There is a problem"
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                        text: "Enter the street name"
          expect(response.body).to have_link "Enter the street name",
                                             href: "#street_name"
          expect(response.body).to have_css "#street_name"
        end
      end

      context "when the street name is a whitespace" do
        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=+&town=london"
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        it "displays the correct error message" do
          expect(response.body).to include(
            '<p id="street_name-error" class="govuk-error-message">
            <span class="govuk-visually-hidden">Error: </span>Enter the street name
          </p>',
          )
        end

        it "contains the required GDS error summary" do
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                        text: "There is a problem"
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                        text: "Enter the street name"
          expect(response.body).to have_link "Enter the street name",
                                             href: "#street_name"
          expect(response.body).to have_css "#street_name"
        end
      end

      context "when missing the town" do
        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=18%20Palmers%20Road&town="
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        it "has an error title" do
          expect(response.body).to include(
            "<title>Error: What is the address? – Find an energy certificate – GOV.UK</title>\n",
          )
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "What is the address",
          )
        end

        it "displays an error message" do
          expect(response.body).to include(
            '<p id="town-error" class="govuk-error-message">',
          )
          expect(response.body).to include("Enter the town")
        end

        it "contains the required GDS error summary" do
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                        text: "There is a problem"
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                        text: "Enter the town"
          expect(response.body).to have_link "Enter the town or city",
                                             href: "#town"
          expect(response.body).to have_css "#town"
        end
      end

      context "when both town and street name are missing" do
        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=&town="
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        it "has an error title" do
          expect(response.body).to include(
            "<title>Error: What is the address? – Find an energy certificate – GOV.UK</title>\n",
          )
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "What is the address",
          )
        end

        it "displays an error message" do
          expect(response.body).to include(
            '<p id="town-error" class="govuk-error-message">',
          )
          expect(response.body).to include("Enter the town")
          expect(response.body).to include(
            '<p id="street_name-error" class="govuk-error-message">',
          )
          expect(response.body).to include("Enter the street name")
        end

        it "contains the required GDS error summary" do
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                        text: "There is a problem"
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                        text: "Enter the street"

          expect(
            response.body,
          ).to have_css "div.govuk-error-summary__body ul.govuk-list li:nth-child(2) a",
                        text: "Enter the town or city"

          expect(response.body).to have_link "Enter the town or city",
                                             href: "#town"

          expect(response.body).to have_link "Enter the street name",
                                             href: "#street_name"
          expect(response.body).to have_css "#street_name"
        end
      end

      context "when no certificates are present" do
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

        it "has a title indicating no results" do
          expect(response.body).to include(
            "<title>A certificate was not found at this address – Find an energy certificate – GOV.UK</title>",
          )
        end

        it "displays the find a certificate page heading" do
          expect(response.body).to include(
            "What is the address?",
          )
        end

        it "explains that no certificates are present" do
          expect(response.body).to include(
            "A certificate was not found at this address",
          )
        end

        it "explains only properties with EPCs are listed" do
          expect(response.body).to include(
            "We only list properties with EPCs",
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

        it "does not contain the GDS error summary" do
          expect(
            response.body,
          ).not_to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                            text: "There is a problem"

          expect(
            response.body,
          ).not_to have_link "A certificate was not found at this address."
        end
      end

      context "when there are too many certificates present" do
        before do
          CertificatesGateway::TooManyResultsStub.search_by_street_name_and_town("1", "London", assessment_types: %w[AC-CERT AC-REPORT CEPC CEPC-RR DEC DEC-RR])
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=1&town=London"
        end

        it "returns a 200 response" do
          expect(response.status).to eq(200)
        end

        it "displays the link to the domestic postcode" do
          expect(response.body).to have_link("Search by postcode instead", href: "/find-a-non-domestic-certificate/search-by-postcode")
        end
      end

      context "when there is no connection" do
        before do
          FindCertificate::NoNetworkStub.search_by_street_name_and_town(
            "Doesnt Matter",
            "Nothing",
            assessment_types: %w[AC-CERT AC-REPORT CEPC CEPC-RR DEC DEC-RR],
          )
        end

        let(:response) do
          get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=Doesnt%20Matter&town=Nothing"
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

    context "when entering a street name and town as an array" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name[]=1%20Makeup%20Street&town[]=Beauty%20Town"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end
    end
  end

  describe ".get find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number",
           type: :feature do
    context "when search page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number"
      end

      it "includes the gov header" do
        expect(response.body).to have_link "Find an energy certificate"
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end

      it "displays the title" do
        expect(response.body).to include(
          "<title>What is the certificate or report number? – Find an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to have_css "h1",
                                          text: "What is the certificate or report number?"
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

      it "displays an error in the title" do
        expect(response.body).to include(
          "<title>Error: What is the certificate or report number? – Find an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to include(
          "What is the certificate or report number?",
        )
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<p id="reference_number-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a 20-digit certificate number")
      end

      it "contains the required GDS error summary" do
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                      text: "There is a problem"
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                      text: "Enter a 20-digit certificate number"
        expect(
          response.body,
        ).to have_link "Enter a 20-digit certificate number",
                       href: "#reference_number"
        expect(response.body).to have_css "#reference_number"
      end
    end

    context "when entering a valid certificate number" do
      context "when the number exists in the register" do
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
      end

      context "when the number exists in the register and the site is being viewed in Welsh" do
        before do
          FindCertificate::Stub.search_by_id("1234-5678-9101-1121-3141", "CEPC")
        end

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

      context "when no certificates are present" do
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
            "What is the certificate or report number?",
          )
        end

        it "explains that no certificates are present" do
          expect(response.body).to include(
            "A certificate was not found with this certificate number",
          )
        end

        it "displays an error in the title" do
          expect(response.body).to include(
            "<title>Error: What is the certificate or report number? – Find an energy certificate – GOV.UK</title>",
          )
        end

        it "contains the required GDS error summary" do
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                        text: "There is a problem"
          expect(
            response.body,
          ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                        text:
                          "A certificate was not found with this certificate number"
          expect(
            response.body,
          ).to have_link "A certificate was not found with this certificate number",
                         href: "#reference_number"
          expect(response.body).to have_css "#reference_number"
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

        context "when the search on the API times out" do
          before do
            FindCertificate::TimeoutStub.search_by_street_name_and_town(
              "Doesnt Matter",
              "Nothing",
              assessment_types: %w[AC-CERT AC-REPORT CEPC CEPC-RR DEC DEC-RR],
            )
          end

          let(:response) do
            get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=Doesnt%20Matter&town=Nothing"
          end

          it "returns status 200" do
            expect(response.status).to eq(200)
          end

          it "displays the search area too big page heading" do
            expect(response.body).to have_css("h1", text: "Sorry, this area is too big to search")
          end

          it "displays a link to the non domestic search by postcode" do
            expect(response.body).to have_link("Search by postcode instead", href: "/find-a-non-domestic-certificate/search-by-postcode")
          end
        end
      end
    end

    context "when entering the reference number as an array" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-reference-number?reference_number[]=1234-5678-9101-1121-3141"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end
    end
  end
end
