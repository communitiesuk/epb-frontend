# frozen_string_literal: true

describe "Journey::FindDomesticCertificate", type: :feature, journey: true do
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

  context "when searching for a domestic certificate" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
    end

    context "with a postcode for which certificates exist" do
      before do
        fill_in "postcode", with: "SW1A 2AA"
        click_button "Find"
      end

      it "shows existence of those certificates on the search results page" do
        expect(page).to have_content "2 EPCs for SW1A 2AA"
      end

      context "when selecting a known certificate from the results list" do
        before do
          click_on "2 Marsham Street, London, SW1A 2AA", match: :first
        end

        it "shows the certificate with the expected header" do
          expect(page).to have_content "Energy performance certificate (EPC)"
        end

        it "shows the searched for postcode within the address in the certificate" do
          expect(page).to have_content "SW1A 2AA"
        end
      end

      context "when selecting a certificate and then clicking on the back link" do
        before do
          click_on "2 Marsham Street, London, SW1A 2AA", match: :first
          click_on "Back"
        end

        it "shows the postcode's search results page again" do
          expect(page).to have_current_path("/find-a-certificate/search-by-postcode?postcode=SW1A+2AA")
        end
      end

      context "when selecting to get a new energy certificate" do
        before do
          click_on "get a new energy certificate"
        end

        it "shows the getting a new energy certificate page" do
          expect(page.find("h1")).to have_content "Getting a new energy certificate"
        end
      end
    end

    context "with a postcode for which no certificates exist" do
      before do
        fill_in "postcode", with: "E1 4FF"
        click_on "Find"
      end

      context "when clicking on the link to get a new energy certificate" do
        before do
          click_link "get a new energy certificate"
        end

        it "shows the getting a new energy certificate page" do
          expect(page.find("h1")).to have_content "Getting a new energy certificate"
        end
      end

      context "when clicking on the link to perform a search by postcode" do
        before do
          click_link "postcode"
        end

        it "shows the find EPC by postcode page" do
          expect(page.find("h1")).to have_content "Find an energy performance certificate (EPC) by postcode"
        end
      end

      context "when clicking on the link to perform a search by street and town" do
        before do
          click_link "street and town"
        end

        it "shows the find EPC by street and town page" do
          expect(page.find("h1")).to have_content "Find an energy performance certificate (EPC) by street and town"
        end
      end

      context "when clicking on the link to perform a search by certificate number" do
        before do
          click_link "certificate number"
        end

        it "shows the find EPC by certificate number page" do
          expect(page.find("h1")).to have_content "Find an energy performance certificate (EPC) by certificate number"
        end
      end
    end

    context "with an empty postcode" do
      before do
        fill_in "postcode", with: ""
        click_on("Find")
      end

      it "shows an error page with validation including a link to the form element", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end

    context "with an invalid postcode" do
      before do
        fill_in "postcode", with: "NOT A POSTCODE"
        click_on "Find"
      end

      it "shows an appropriate error message to enter a valid postcode" do
        expect(page).to have_content "Enter a real postcode"
      end
    end

    context "with a certificate number (RRN)" do
      before do
        click_on "find an EPC by using its certificate number"
      end

      context "when the certificate number exists" do
        before do
          fill_in "reference_number", with: "4567-6789-4567-6789-4567"
          click_on "Find"
        end

        it "shows the certificate page", :aggregate_failures do
          expect(page).to have_content "2 Marsham Street"
          expect(page).to have_content "Valid until"
          expect(page).to have_content "5 January 2030"
        end
      end

      context "when the certificate number has a valid format but does not exist" do
        before do
          fill_in "reference_number", with: "9900-0000-0000-0000-0099"
          click_on "Find"
        end

        it "shows an error page with a message that no certificate was found with the number", :aggregate_failures do
          expect(page).to have_content "A certificate was not found with this certificate number"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "A certificate was not found with this certificate number"
        end
      end

      context "when the certificate number is too long" do
        before do
          fill_in "reference_number", with: "4567-6789-4567-6789-4567-1234"
          click_on "Find"
        end

        it "displays an error page with a validation link to the form element", :aggregate_failures do
          expect(page).to have_content "Enter a 20-digit certificate number"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter a 20-digit certificate number"
        end
      end
    end

    context "with street and town" do
      before do
        click_on "find an EPC using the street name and town"
      end

      context "when searching with a street and town that match known certificates" do
        before do
          fill_in "street_name", with: "1 Makeup Street"
          fill_in "town", with: "Beauty Town"
          click_on "Find"
        end

        it "shows a results page indicating matching results" do
          expect(page).to have_content "of 1 results matching"
        end
      end

      context "when searching with a street and town that do not match known certificates" do
        before do
          fill_in "street_name", with: "Madeup Street"
          fill_in "town", with: "Madeup Town"
          click_on "Find"
        end

        it "shows a message saying that no certificates were found for the given location" do
          expect(page).to have_content "A certificate was not found at this address."
        end
      end

      context "when searching with an empty street name" do
        before do
          fill_in "town", with: "Beauty Town"
          click_on "Find"
        end

        it "shows an error page with the message to enter a street", :aggregate_failures do
          expect(page).to have_content "Enter the street name"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the street name"
        end
      end

      context "when searching with an empty town name" do
        before do
          fill_in "street_name", with: "1 street ave"
          click_on "Find"
        end

        it "shows an error page with the message to enter a town", :aggregate_failures do
          expect(page).to have_content "Enter the town or city"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the town or city"
        end
      end

      context "when searching with empty street and town" do
        before do
          click_on "Find"
        end

        it "shows an error page with messages both to enter a street and enter a town", :aggregate_failures do
          expect(page).to have_content "Enter the town"
          expect(page).to have_content "Enter the street name"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the town or city"
          expect(page).to have_link "Enter the street name"
        end
      end

      context "when searching with a street and town that have no matching certificates and clicking the link to get a new certificate" do
        before do
          fill_in "street_name", with: "Madeup Street"
          fill_in "town", with: "Madeup Town"
          click_on "Find"
          click_on "get a new energy certificate"
        end

        it "shows the getting a new certificate start page" do
          expect(page.find("h1")).to have_content "Getting a new energy certificate"
        end
      end
    end
  end

  context "when accessing a certificate page via a provided link" do
    context "with a certificate that exists" do
      before do
        visit "http://find-energy-certificate.local.gov.uk:9393/energy-certificate/4567-6789-4567-6789-4567"
      end

      it "does not display a back link" do
        expect(page).not_to have_content("Back")
      end
    end

    context "with a certificate that is cancelled or not for issue" do
      before do
        visit "http://find-energy-certificate.local.gov.uk:9393/energy-certificate/0000-0000-0000-0000-0666"
      end

      it "shows a page that links to the find an energy certificate page", :aggregate_failures do
        expect(page).to have_link "Find an energy certificate"
        within("main") { click_link "Find an energy certificate" }
        expect(page).to have_content "Find an energy certificate"
      end
    end
  end

  describe "when navigating to a certificate" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC by using its certificate number"
      fill_in "reference_number", with: "4567-6789-4567-6789-4567"
      click_on "Find"
    end

    it "displays a backlink on the page" do
      expect(page).to have_content "Back"
    end
  end

  context "when clicking continue without selecting type of property" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      click_on "Continue"
    end

    it "shows an error page with a validation that links to the form elements for choosing a type of property", :aggregate_failures do
      expect(page).to have_content "Select a type of property"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Select a type of property"
    end
  end

  context "when using the site in Welsh and performing a search on a postcode with domestic certificates against it" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Welsh (Cymraeg)"
      click_on "Dechreuwch nawr"
      find("#label-domestic").click
      click_on "Parhau"
      fill_in "postcode", with: "SW1A 2AA"
      click_button "Chwiliwch"
    end

    it "shows the expected results page for the postcode, in Welsh" do
      expect(page).to have_content "2 EPCs ar gyfer SW1A 2AA"
    end
  end
end
