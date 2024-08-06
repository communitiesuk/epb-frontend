# frozen_string_literal: true

describe "Acceptance::NonDomesticAssessor", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate/find-a-non-domestic-assessor/search-by-postcode" do
    context "when search page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode"
      end

      it "includes the gov header" do
        expect(response.body).to include(
          "<a href=\"/\" class=\"govuk-header__link govuk-header__service-name\">Get a new energy certificate</a>",
        )
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the find an assessor by postcode title" do
        expect(response.body).to include(
          "<title>What is the property’s postcode? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find a non-domestic assessor page heading" do
        expect(response.body).to include("What is the property’s postcode?")
      end

      it "has a postcode input field" do
        expect(response.body).to include('<input id="postcode" name="postcode"')
      end

      it "has a Find button" do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Find</button>',
        )
      end

      it "has a link to find the postcode if you don't know it" do
        expect(response.body).to include(
          '<a class="govuk-link" href="https://www.royalmail.com/find-a-postcode">Find a postcode on Royal Mail’s postcode finder</a>',
        )
      end

      it "does not display an error message" do
        expect(response.body).not_to include("govuk-error-message")
      end
    end

    context "when entering an empty postcode" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode error title" do
        expect(response.body).to include(
          "<title>Error: What is the property’s postcode? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find a non-domestic assessor page heading" do
        expect(response.body).to include("What is the property’s postcode?")
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

    context "when entering an invalid postcode" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=NOT+A+POSTCODE"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode error title" do
        expect(response.body).to include(
          "<title>Error: What is the property’s postcode? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor page heading" do
        expect(response.body).to include("What is the property’s postcode?")
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

    context "when entering a postcode that is over 10 characters" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=++SW1A+2AA7A8++"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode error title" do
        expect(response.body).to include(
          "<title>Error: What is the property’s postcode? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor page heading" do
        expect(response.body).to include("What is the property’s postcode?")
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

    context "when entering a postcode that is less than 5 characters" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=OX29"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode error title" do
        expect(response.body).to include(
          "<title>Error: What is the property’s postcode? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor page heading" do
        expect(response.body).to include("What is the property’s postcode?")
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode[]=E39GG"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end
    end

    context "when entering a valid postcode" do
      context "with surrounding whitespaces" do
        before do
          FindAssessor::ByPostcode::Stub.search_by_postcode(
            "SW1A 2AA",
            "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=++SW1A+2AA++"
        end

        it "returns status 200" do
          expect(response.status).to eq 200
        end
      end

      context "when showing results page" do
        before do
          FindAssessor::ByPostcode::Stub.search_by_postcode(
            "SW1A 2AA",
            "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=SW1A+2AA"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the correct title" do
          expect(response.body).to include(
            "<title>7 assessors in order of distance from SW1A 2AA – Get a new energy certificate – GOV.UK</title>",
          )
        end

        it "displays the contact an assessor to book an energy assessment page heading" do
          expect(response.body).to include(
            "7 assessors in order of distance from SW1A 2AA",
          )
        end

        it "displays the to search again by postcode message" do
          expect(response.body).to include("Enter a postcode to search again")
        end

        it "has a postcode input field" do
          expect(response.body).to include(
            '<input id="postcode" name="postcode"',
          )
        end

        it "has a search icon button" do
          expect(response.body).to include(
            '<button class="epc-search-button" data-module="govuk-button" aria-label="Find"></button>',
          )
        end

        it "shows the assessor ID of an entry" do
          expect(response.body).to include("CIBSE9999990")
        end

        it "shows the name of an entry" do
          expect(response.body).to include("Juan Uno")
        end

        it "shows the email of an entry" do
          expect(response.body).to include("user@example.com")
        end

        it "shows a clickable email" do
          expect(response.body).to include("mailto:user@example.com")
        end

        it "downcases the email of an entry" do
          expect(response.body).not_to include("UPPERCASE_EMAIL@eXaMpLe.com")
          expect(response.body).to include("uppercase_email@example.com")
        end

        it "shows a downcased clickable email" do
          expect(response.body).not_to include(
            "mailto:UPPERCASE_EMAIL@eXaMpLe.com",
          )
          expect(response.body).to include("mailto:uppercase_email@example.com")
        end

        it "shows a phone number of an entry" do
          expect(response.body).to include("07921 021 368")
        end

        context "when contacting schemes" do
          it "has a more information link under scheme name" do
            expect(response.body).to include("More information")
          end

          it "shows CIBSE contact details" do
            expect(response.body).to include(
              "Contact details for CIBSE Certification Limited:",
            )
            expect(response.body).to include("epc@cibsecertification.org")
            expect(response.body).to include("020 8772 3649")
          end

          it "shows Quidos contact details" do
            expect(response.body).to include(
              "Contact details for Quidos Limited:",
            )
            expect(response.body).to include("info@quidos.co.uk")
            expect(response.body).to include("01225 667 570")
          end

          it "shows unaccredited EPB 4 U scheme" do
            expect(response.body).to include("EPB 4 U is no longer accredited.")
          end

          it "shows Stroma contact details" do
            expect(response.body).to include(
              "Contact details for Stroma Certification Ltd:",
            )
            expect(response.body).to include("certification@stroma.com")
            expect(response.body).to include("0330 124 9660")
          end

          it "shows Sterling contact details" do
            expect(response.body).to include(
              "Contact details for Sterling Accreditation Ltd:",
            )
            expect(response.body).to include("info@sterlingaccreditation.com")
            expect(response.body).to include("0161 727 4303")
          end

          it "shows Elmhurst contact details" do
            expect(response.body).to include(
              "Contact details for Elmhurst Energy Systems Ltd:",
            )
            expect(response.body).to include("enquiries@elmhurstenergy.co.uk")
            expect(response.body).to include("01455 883 250")
          end

          it "shows ECMK contact details" do
            expect(response.body).to include(
              "Contact details for Sterling Accreditation Ltd:",
            )
            expect(response.body).to include("info@ecmk.co.uk")
            expect(response.body).to include("0333 123 1418")
          end
        end

        it "shows qualifications of an entry" do
          expect(response.body).to include(
            "Standard Assessment Procedure (SAP)",
          )
          expect(response.body).to include(
            "Reduced Data Standard Assessment Procedure (RdSAP)",
          )
          expect(response.body).to include(
            "Air Conditioning Simple Packaged (Level 3)",
          )
          expect(response.body).to include(
            "Air Conditioning Complexed Central (Level 4)",
          )
          expect(response.body).to include("Display Energy Certificate (DEC)")
          expect(response.body).to include(
            "Non-Domestic Energy Assessor (Level 3)",
          )
          expect(response.body).to include(
            "Non-Domestic Energy Assessor (Level 4)",
          )
          expect(response.body).to include(
            "Non-Domestic Energy Assessor (Level 5)",
          )
        end
      end

      context "with no assessors nearby" do
        before do
          FindAssessor::ByPostcode::NoNearAssessorsStub.search_by_postcode(
            "E1 4AA",
            "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=E1+4AA"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the correct title" do
          expect(response.body).to include(
            "<title>No results for E1 4AA – Get a new energy certificate – GOV.UK</title>",
          )
        end

        it "displays the no results page heading" do
          expect(response.body).to include(
            "No results for E1 4AA",
          )
        end

        it "explains that no assessors are nearby" do
          expect(response.body).to include(
            "We did not find any assessors for E1 4AA.",
          )
        end
      end

      context "with a postcode that doesnt exist" do
        before do
          FindAssessor::ByPostcode::UnregisteredPostcodeStub.search_by_postcode(
            "B11 4FF",
            "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=B11+4FF"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "has a title that matches the page heading" do
          expect(response.body).to include(
            "<title>No results for B11 4FF – Get a new energy certificate – GOV.UK</title>",
          )
        end

        it "displays the no results page heading" do
          expect(response.body).to include(
            "No results for B11 4FF",
          )
        end

        it "displays the no results found message" do
          expect(response.body).to include(
            "We did not find any assessors for B11 4FF",
          )
        end

        it "displays the link to postcode finder" do
          expect(response.body).to include(
            '<a class="govuk-link" href="https://www.royalmail.com/find-a-postcode">',
          )
        end
      end

      context "with a malformed postcode" do
        before do
          FindAssessor::ByPostcode::InvalidPostcodeStub.search_by_postcode(
            "H0H 0H0",
            "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=H0H+0H0"
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        it "has a title that matches the page heading" do
          expect(response.body).to include(
            "<title>Error: What is the property’s postcode? – Get a new energy certificate – GOV.UK</title>",
          )
        end

        it "displays find a non-domestic assessor page heading" do
          expect(response.body).to include("What is the property’s postcode?")
        end

        it "displays an error message" do
          expect(response.body).to include(
            '<p id="postcode-error" class="govuk-error-message">',
          )
          expect(response.body).to include("Enter a valid UK postcode using only letters and numbers in the format LS1 4AP")
        end
      end

      context "when there is no connection" do
        before do
          FindAssessor::ByPostcode::NoNetworkStub.search_by_postcode(
            "D11 4FF",
            qualification_type: "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=D11+4FF"
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

  describe ".get /find-a-non-domestic-assessor/search-by-name" do
    context "when search page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name"
      end

      it "includes the gov header" do
        expect(response.body).to have_link "Get a new energy certificate"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the Find an assessor by name title" do
        expect(response.body).to include(
          "<title>What is the assessor’s name? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the Find an assessor by name page heading" do
        expect(response.body).to have_css "h1", text: "What is the assessor’s name?"
      end

      it "has a postcode input field" do
        expect(response.body).to include('<input id="name" name="name"')
      end

      it "has a Search button" do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Search</button>',
        )
      end

      it "does not display an error message" do
        expect(response.body).not_to include("govuk-error-message")
      end
    end

    context "when entering an empty name" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the Find an assessor by name title" do
        expect(response.body).to include(
          "<title>Error: What is the assessor’s name? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays the Find an assessor by name page heading" do
        expect(response.body).to have_css "h1", text: "What is the assessor’s name?"
      end

      it "displays an error message" do
        expect(response.body).to have_css ".govuk-error-message",
                                          text: "Enter a first name and last name"
      end

      it "contains the required GDS error summary" do
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                      text: "There is a problem"
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                      text: "Enter a first name and last name"
        expect(
          response.body,
        ).to have_link "Enter a first name and last name",
                       href: "#name"
        expect(response.body).to have_css "#name"
      end
    end

    context "when entering a single name" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name=bob"
      end

      it "displays the Find an assessor by name error title" do
        expect(response.body).to include(
          "<title>Error: What is the assessor’s name? – Get a new energy certificate – GOV.UK</title>",
        )
      end

      it "displays an error message" do
        expect(response.body).to have_css ".govuk-error-message",
                                          text: "Enter a first name and last name"
      end

      it "contains the required GDS error summary" do
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary h2.govuk-error-summary__title",
                      text: "There is a problem"
        expect(
          response.body,
        ).to have_css "div.govuk-error-summary__body ul.govuk-list li:first a",
                      text: "Enter a first name and last name"
        expect(
          response.body,
        ).to have_link "Enter a first name and last name",
                       href: "#name"
        expect(response.body).to have_css "#name"
      end
    end

    context "when entering a name" do
      context "with exact matches" do
        before { FindAssessor::ByName::Stub.search_by_name("Ronald McDonald", "nonDomestic") }

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name=Ronald%20McDonald"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the correct title" do
          expect(response.body).to include(
            "<title>8 results for the name Ronald McDonald – Get a new energy certificate – GOV.UK</title>",
          )
        end

        it "displays the results count as the heading" do
          expect(response.body).to have_css "h1",
                                            text: "8 results for the name Ronald McDonald"
        end

        it "has a name input field" do
          expect(response.body).to include('<input id="name" name="name"')
        end

        it "has a Search button" do
          expect(response.body).to include(
            '<button class="epc-search-button" data-module="govuk-button" aria-label="Search"></button>',
          )
        end

        it "shows the name of an entry" do
          expect(response.body).to include("Supercommon Name")
        end

        it "shows qualifications", :aggregate_failures do
          expect(response.body).to include("Air Conditioning Simple Packaged (Level 3)")
          expect(response.body).to include("Air Conditioning Complexed Central (Level 4)")
          expect(response.body).to include("Display Energy Certificate (DEC)")
          expect(response.body).to include("Non-Domestic Energy Assessor (Level 3)")
          expect(response.body).to include("Non-Domestic Energy Assessor (Level 4)")
          expect(response.body).to include("Non-Domestic Energy Assessor (Level 5)")
          expect(response.body).not_to include("Green Deal Assessor")
        end

        it "shows the assessor ID of an entry" do
          expect(response.body).to include("Stroma9999990")
        end

        it "shows the email of an entry" do
          expect(response.body).to include("user@example.com")
        end

        it "shows a clickable email" do
          expect(response.body).to include("mailto:user@example.com")
        end

        it "downcases the email of an entry" do
          expect(response.body).not_to include("UPPERCASE_EMAIL@eXaMpLe.com")
          expect(response.body).to include("uppercase_email@example.com")
        end

        it "shows a downcased clickable email" do
          expect(response.body).not_to include(
            "mailto:UPPERCASE_EMAIL@eXaMpLe.com",
          )
          expect(response.body).to include("mailto:uppercase_email@example.com")
        end

        it "shows a phone number of an entry" do
          expect(response.body).to include("07921 021 368")
        end

        it "does not show that they are loose matches" do
          expect(response.body).not_to include("similar to")
        end
      end

      context "with similar matches" do
        before do
          FindAssessor::ByName::Stub.search_by_name(
            "R%20McDonald",
            "nonDomestic",
            loose_match: true,
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name=R%20McDonald"
        end

        it "displays the correct title" do
          expect(response.body).to have_title(
            "8 results similar to the name R McDonald – Get a new energy certificate – GOV.UK",
          )
        end

        it "does show that they are loose matches" do
          expect(response.body).to include("similar to")
        end
      end

      context "when no assessors have that name" do
        before do
          FindAssessor::ByName::NoAssessorsStub.search_by_name(
            "Nonexistent Person",
            "nonDomestic",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name=Nonexistent%20Person"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the correct title" do
          expect(response.body).to have_title(
            "No results for the name Nonexistent Person – Get a new energy certificate – GOV.UK",
          )
        end

        it "displays the result count as the main heading" do
          expect(response.body).to have_css "h1",
                                            text: "No results for the name Nonexistent Person"
        end

        it "explains that no assessors by that name" do
          expect(response.body).to include(
            "There are no assessors with this name.",
          )
        end
      end

      context "when there is no connection" do
        before do
          FindAssessor::ByName::NoNetworkStub.search_by_name("Breaking Person", qualification_type: "nonDomestic")
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name=Breaking%20Person"
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

    context "when entering a name in an array" do
      before { FindAssessor::ByName::Stub.search_by_name("Ronald McDonald", "nonDomestic") }

      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-name?name[]=Ronald%20McDonald"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end
    end
  end
end
