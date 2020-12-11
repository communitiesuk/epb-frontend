# frozen_string_literal: true

describe "Acceptance::NonDomesticAssessor" do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate/find-a-non-domestic-assessor/search-by-postcode" do
    context "when search page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the find a non-domestic assessor page heading" do
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a non-domestic assessor page heading" do
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=NOT+A+POSTCODE"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor page heading" do
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=++SW1A+2AA7A8++"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor page heading" do
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
        get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=OMG"
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find an assessor page heading" do
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

      context "shows results page" do
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

        it "has a tab content that matches the page heading" do
          expect(response.body).to include(
                                       '<title>Contact an assessor to book an energy assessment - Getting an energy certificate - GOV.UK</title>'
                                   )
        end

        it "displays the contact an assessor to book an energy assessment page heading" do
          expect(response.body).to include("Contact an assessor to book an energy assessment")
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

      context "where no assessors are near" do
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

        xit "displays the find a non-domestic assessor page heading" do
          expect(response.body).to include("Find a non-domestic energy assessor")
        end

        it "explains that no assessors are nearby" do
          expect(response.body).to include(
            "We did not find any assessors for E1 4AA.",
          )
        end
      end

      context "where the postcode doesnt exist" do
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

        it "has a tab content that matches the page heading" do
          expect(response.body).to include(
                                       '<title>Contact an assessor to book an energy assessment - Getting an energy certificate - GOV.UK</title>'
                                   )
        end

        xit "displays the find a non-domestic assessor page heading" do
          expect(response.body).to include("Find a non-domestic energy assessor")
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
            "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
          )
        end

        let(:response) do
          get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=C11+4FF"
        end

        it "returns status 400" do
          expect(response.status).to eq(400)
        end

        xit "displays find a non-domestic assessor page heading" do
          expect(response.body).to include(
            "Find a non-domestic energy assessor",
          )
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
          FindAssessor::ByPostcode::NoNetworkStub.search_by_postcode(
            "D11 4FF",
            "nonDomesticSp3,nonDomesticCc4",
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
end
