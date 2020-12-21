# frozen_string_literal: true

describe "Acceptance::Assessor", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate/find-an-assessor/type-of-property" do
    context "when on page to decide property type" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/type-of-property"
      end

      it "displays the tab value the same as the main header value" do
        expect(response.body).to include(
          "<title>What type of property is the certificate for? – Getting an energy certificate – GOV.UK</title>",
        )
      end
    end
  end

  describe ".get getting-new-energy-certificate/find-an-assessor/search-by-postcode" do
    context "when search page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the find an assessor by postcode tab heading" do
        expect(response.body).to include(
          "<title>Find an assessor by postcode – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor by postcode page heading" do
        expect(response.body).to include("Find an assessor by postcode")
      end

      it "has a postcode input field" do
        expect(response.body).to include('<input id="postcode" name="postcode"')
      end

      it "has a Find button" do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Find</button>',
        )
      end

      it "does not display an error message" do
        expect(response.body).not_to include("govuk-error-message")
      end
    end

    context "when entering an empty postcode" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode tab heading" do
        expect(response.body).to include(
          "<title>Error: Find an assessor by postcode – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor by postcode page heading" do
        expect(response.body).to include("Find an assessor by postcode")
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=++SW1A+2AA7A8++"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode tab heading" do
        expect(response.body).to include(
          "<title>Error: Find an assessor by postcode – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor by postcode page heading" do
        expect(response.body).to include("Find an assessor by postcode")
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=ETC"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode tab heading" do
        expect(response.body).to include(
          "<title>Error: Find an assessor by postcode – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor by postcode page heading" do
        expect(response.body).to include("Find an assessor by postcode")
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a real postcode")
      end
    end

    context "when entering an invalid postcode" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=NOT+A+POSTCODE"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor by postcode tab heading" do
        expect(response.body).to include(
          "<title>Error: Find an assessor by postcode – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the find an assessor by postcode page heading" do
        expect(response.body).to include("Find an assessor by postcode")
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
        before { FindAssessor::ByPostcode::Stub.search_by_postcode("SW1A 2AA") }

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=++SW1A+2AA++"
        end

        it "returns status 200" do
          expect(response.status).to eq 200
        end
      end

      context "show results page" do
        before { FindAssessor::ByPostcode::Stub.search_by_postcode("SW1A 2AA") }

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=SW1A+2AA"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the Contact an Assessor To Book An Energy Assessment tab heading" do
          expect(response.body).to include(
            "<title>Contact an assessor to book an energy assessment – Getting an energy certificate – GOV.UK</title>",
          )
        end

        it "displays the Contact an assessor to book an energy assessment page heading" do
          expect(response.body).to have_css "h1",
                                            text: "Contact an assessor to book an energy assessment"
        end

        it "displays the to search again by postcode message" do
          expect(response.body).to include("To search again")
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
            expect(response.body).to include("info@sterlingaccreditaiton.com")
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
      end

      context "where no assessors are near" do
        before do
          FindAssessor::ByPostcode::NoNearAssessorsStub.search_by_postcode(
            "E1 4FF",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=E1+4FF"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the find an assessor page heading" do
          expect(response.body).to have_css "h1",
                                            text: "Contact an assessor to book an energy assessment"
        end

        it "explains that no assessors are nearby" do
          expect(response.body).to include(
            "We did not find any assessors for E1 4FF.",
          )
        end
      end

      context "where the postcode doesnt exist" do
        before do
          FindAssessor::ByPostcode::UnregisteredPostcodeStub.search_by_postcode(
            "B11 4FF",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=B11+4FF"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the find an assessor page heading" do
          expect(response.body).to have_css "h1",
                                            text: "Contact an assessor to book an energy assessment"
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

      context "where the requested postcode is malformed" do
        before do
          FindAssessor::ByPostcode::InvalidPostcodeStub.search_by_postcode(
            "C11 4FF",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=C11+4FF"
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        it "displays the Contact an assessor page heading" do
          expect(response.body).to have_css "h1",
                                            text: "Find an assessor by postcode"
        end

        it "displays an error message" do
          expect(response.body).to include(
            '<span id="postcode-error" class="govuk-error-message">',
          )
          expect(response.body).to include("Enter a real postcode")
        end
      end

      context "when there is no connection" do
        before do
          FindAssessor::ByPostcode::NoNetworkStub.search_by_postcode("D11 4FF")
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-postcode?postcode=D11+4FF"
        end

        it "returns status 500" do
          expect(response.status).to eq(500)
        end

        it "displays the 500 error page tab title" do
          expect(response.body).to include(
                                       "<title>Error: Sorry, there is a problem with the service - GOV.UK</title>",
                                       )
        end

        it "displays error page body" do
          expect(response.body).to include(
            "Sorry, there is a problem with the service",
          )
        end
      end
    end
  end

  describe ".get /find-an-assessor/search-by-name" do
    context "when search page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the Find an assessor by name tab heading" do
        expect(response.body).to include(
          "<title>Find an assessor by name – Getting an energy certificate – GOV.UK</title>",
        )
      end

      it "displays the Find an assessor by name page heading" do
        expect(response.body).to have_css "h1", text: "Find an assessor by name"
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name?name="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the Find an assessor by name tab heading" do
        expect(response.body).to include(
                                     "<title>Error: Find an assessor by name – Getting an energy certificate – GOV.UK</title>",
                                     )
      end

      it "displays the Find an assessor by name page heading" do
        expect(response.body).to have_css "h1", text: "Find an assessor by name"
      end

      it "displays an error message" do
        expect(response.body).to have_css "span",
                                          text: "Enter the first and last name of the assessor"
      end
    end

    context "when entering a single name" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name?name=bob"
      end

      it "displays an error message" do
        expect(response.body).to have_css "span",
                                          text: "Enter the first and last name of the assessor"
      end
    end

    context "when entering a name" do
      context "which has exact matches" do
        before { FindAssessor::ByName::Stub.search_by_name("Ronald McDonald") }

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name?name=Ronald%20McDonald"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the Contact an assessor to book an energy assessment tab heading" do
          expect(response.body).to include(
            "<title>Contact an assessor to book an energy assessment – Getting an energy certificate – GOV.UK</title>",
          )
        end

        it "displays the Contact an assessor to book an energy assessment page heading" do
          expect(response.body).to have_css "h1",
                                            text: "Contact an assessor to book an energy assessment"
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
          expect(response.body).to_not include("similar to")
        end
      end

      context "which has similar matches" do
        before do
          FindAssessor::ByName::Stub.search_by_name("Ronald McDonald", true)
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name?name=R%20McDonald"
        end

        it "does show that they are loose matches" do
          expect(response.body).to include("similar to")
        end
      end

      context "where no assessors have that name" do
        before do
          FindAssessor::ByName::NoAssessorsStub.search_by_name(
            "Nonexistent Person",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name?name=Nonexistent%20Person"
        end

        it "returns status 200" do
          expect(response.status).to eq(200)
        end

        it "displays the Contact an assessor to book an energy assessment tab heading" do
          expect(response.body).to include(
            "<title>Contact an assessor to book an energy assessment – Getting an energy certificate – GOV.UK</title>",
          )
        end

        it "displays the Contact an assessor to book an energy assessment page heading" do
          expect(response.body).to have_css "h1",
                                            text: "Contact an assessor to book an energy assessment"
        end

        it "explains that no assessors by that name" do
          expect(response.body).to include(
            "There are no assessors with this name.",
          )
        end
      end

      context "when there is no connection" do
        before do
          FindAssessor::ByName::NoNetworkStub.search_by_name("Breaking Person")
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/search-by-name?name=Breaking%20Person"
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
