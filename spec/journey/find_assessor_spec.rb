# frozen_string_literal: true

describe "Journey::FindAssessor", type: :feature, journey: true do
  let(:getting_domain) do
    "http://getting-new-energy-certificate.local.gov.uk:9393"
  end

  process_id = nil

  before(:all) do
    process =
      IO.popen(
        [
          "rackup",
          "config_test.ru",
          "-q",
          "-o",
          "127.0.0.1",
          "-p",
          "9393",
          { err: %i[child out] },
        ],
      )
    process_id = process.pid

    nil unless process.readline.include?("port=9393")
  end

  after(:all) { Process.kill("KILL", process_id) if process_id }

  context "when finding a domestic assessor by postcode" do
    before do
      visit getting_domain
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
    end

    context "when searching on a postcode that has known assessors associated" do
      before do
        fill_in "postcode", with: "SW1A 2AA"
        click_on "Find"
      end

      it "shows assessor search results" do
        expect(page).to have_content "7 assessors in order of distance from SW1A 2AA"
      end

      it "display a link to search again" do
        expect(page).to have_content "To search again, enter the postcode of the property"
      end

      context "when clicking the 'more information' link for the first assessor in the results" do
        before do
          find("span", text: "More information", match: :first).click
        end

        it "displays accreditation scheme contact details for this assessor", :aggregate_failures do
          expect(page).to have_content "epc@cibsecertification.org"
          expect(page).to have_content "020 8772 3649"
        end
      end

      context "when clicking the 'more information' link for an assessor with a scheme that is no longer accredited" do
        before do
          find_all("span", text: "More information")[4].click
        end

        it "displays text saying the scheme is no longer accredited" do
          expect(page).to have_content "EPB 4 U is no longer accredited."
        end
      end
    end

    context "when attempting to search using an empty postcode" do
      before do
        fill_in "postcode", with: ""
        click_on "Find"
      end

      it "shows an error message indicating a valid postcode should be entered", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end

    context "when entering an invalid postcode" do
      before do
        fill_in "postcode", with: "NOT A POSTCODE"
        click_on "Find"
      end

      it "shows an error message indicating a valid postcode should be entered", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end
  end

  context "when finding a domestic assessor by name" do
    before do
      visit getting_domain
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an assessor by name"
    end

    context "when searching on an empty name" do
      before do
        click_on "Search"
      end

      it "shows an error message that the full name being searched should be entered" do
        expect(page).to have_content "Enter the first and last name of the assessor"
      end
    end

    context "when searching with only one name" do
      before do
        fill_in "name", with: "Supercommon"
        click_on "Search"
      end

      it "shows an error message that the full name being searched should be entered" do
        expect(page).to have_content "Enter the first and last name of the assessor"
      end
    end

    context "when a name is searched on matching an assessor who has not supplied an email address or phone number" do
      before do
        fill_in "name", with: "Supercommon Name"
        click_on "Search"
      end

      it "displays error messages that both email and telephone have not been supplied", :aggregate_failures do
        expect(page).to have_content "Email Not Supplied"
        expect(page).to have_content "Telephone Not Supplied"
      end

      it "displays search results for the assessor" do
        expect(page).to have_content "8 results for the name Supercommon Name"
      end

      context "when clicking on a 'more information' link on one of the results" do
        before do
          find_all("span", text: "More information")[2].click
        end

        it "shows accreditation scheme contact details", :aggregate_failures do
          expect(page).to have_content "Contact details for ECMK:"
          expect(page).to have_content "info@ecmk.co.uk"
          expect(page).to have_content "0333 123 1418"
        end
      end
    end
  end

  context "when finding a non-domestic assessor by postcode" do
    before do
      visit "#{getting_domain}/find-an-assessor/type-of-property"
      find("#label-non-domestic").click
      click_on "Continue"
    end

    context "when entering an empty postcode" do
      before do
        fill_in "postcode", with: ""
        click_on "Find"
      end

      it "displays an error message that a valid postcode should be used to search", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end

    context "when entering an invalid postcode" do
      before do
        fill_in "postcode", with: "NOT A POSTCODE"
        click_on "Find"
      end

      it "displays an error message that a valid postcode should be used to search", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end

    context "when entering a postcode for which there are known assessors" do
      before do
        fill_in "postcode", with: "SW1A 2AA"
        click_on "Find"
      end

      it "displays text suggesting that the user can search again by entering the postcode of the property" do
        expect(page).to have_content "To search again, enter the postcode of the property"
      end

      it "displays search results" do
        expect(page).to have_content "7 assessors in order of distance from SW1A 2AA"
      end

      context "when selecting the 'more information' link for a listed assessor" do
        before do
          find_all("span", text: "More information")[1].click
        end

        it "displays accreditation scheme contact details", :aggregate_failures do
          expect(page).to have_content "Contact details for Stroma Certification Ltd:"
          expect(page).to have_content "Email: certification@stroma.com"
          expect(page).to have_content "Telephone: 0330 124 9660"
        end
      end

      context "when selecting the 'more information' link for an assessor with a scheme that is no longer accredited" do
        before do
          find_all("span", text: "More information")[4].click
        end

        it "displays text showing that the scheme is no longer accredited" do
          expect(page).to have_content "EPB 4 U is no longer accredited."
        end
      end
    end
  end

  context "when finding a non-domestic assessor by name" do
    before do
      visit "#{getting_domain}/find-a-non-domestic-assessor/search-by-name"
    end

    context "when searching using an empty name" do
      before do
        click_on "Search"
      end

      it "shows an error message that the full name of the search assessor should be used for search", :aggregate_failures do
        expect(page).to have_content "Enter the first and last name of the assessor"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter the first and last name of the assessor"
      end
    end

    context "when searching using just a first name" do
      before do
        fill_in "name", with: "John"
        click_on "Search"
      end

      it "shows an error message that the full name of the search assessor should be used for search", :aggregate_failures do
        expect(page).to have_content "Enter the first and last name of the assessor"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter the first and last name of the assessor"
      end
    end

    context "when searching with a name that matches known assessors" do
      before do
        fill_in "name", with: "Supercommon Name"
        click_on "Search"
      end

      it "shows a back link to the non-domestic search by name form" do
        expect(page).to have_link("Back", href: /find-a-non-domestic-assessor\/search-by-name/)
      end

      it "displays search results" do
        expect(page).to have_content("8 results for the name Supercommon Name")
      end
    end
  end

  context "when a property type is not chosen at the property type stage" do
    before do
      visit getting_domain
      click_on "Start now"
      click_on "Continue"
    end

    it "displays an error message indicating a property type should be chosen", :aggregate_failures do
      expect(page).to have_content "Select a type of property"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Select a type of property"
    end
  end

  context "when the back link on the type of property step is clicked" do
    before do
      visit getting_domain
      click_on "Start now"
      click_link "Back"
    end

    it "shows the getting a new energy certificate start page" do
      expect(page.find("h1")).to have_content "Getting a new energy certificate"
    end
  end

  context "when a static app for the root page is not configured" do
    it "displays a back link to the root page" do
      visit getting_domain
      click_on "Start now"
      expect(find(".govuk-back-link")[:href]).to eq "#{getting_domain}/"
    end
  end
end
