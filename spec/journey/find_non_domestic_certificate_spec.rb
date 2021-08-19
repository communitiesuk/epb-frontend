# frozen_string_literal: true

describe "Journey::FindNonDomesticCertificate", type: :feature, journey: true do
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

  context "when searching for a non-domestic certificate" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
    end

    context "with a postcode for which certificates exist" do
      before do
        fill_in "postcode", with: "SW1A 2AA"
        click_button "Find"
      end

      it "shows existence of those certificates on the search results page" do
        expect(page).to have_content "2 certificates and reports for SW1A 2AA"
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

      context "when then clicking the link to get a new energy certificate" do
        before do
          click_on "get a new energy certificate"
        end

        it "shows the getting a new energy certificate start page" do
          expect(page.find("h1")).to have_content "Getting a new energy certificate"
        end
      end

      context "when then clicking on the link to search by postcode" do
        before do
          click_link "postcode"
        end

        it "shows the search by postcode page" do
          expect(page.find("h1")).to have_content "Find energy certificates and reports by postcode"
        end
      end

      context "when then clicking on the link to search by street and town" do
        before do
          click_link "street and town"
        end

        it "shows the page for searching by street and town" do
          expect(page.find("h1")).to have_content "Find an energy performance certificate (EPC) by street and town"
        end
      end

      context "when then clicking on the link to search by certificate number" do
        before do
          click_link "certificate number"
        end

        it "shows the page for searching by certificate number" do
          expect(page.find("h1")).to have_content "Find energy certificates and reports by their number"
        end
      end
    end

    context "with an empty postcode" do
      before do
        fill_in "postcode", with: ""
        click_on("Find")
      end

      it "shows an appropriate validation error for not having entered a valid postcode" do
        expect(page).to have_content "Enter a real postcode"
      end
    end

    context "with an invalid postcode" do
      before do
        fill_in "postcode", with: "NOT A POSTCODE"
        click_on "Find"
      end

      it "shows an appropriate validation error for not having entered a valid postcode", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end

    context "with a street name and town" do
      before do
        click_on "find energy certificates and reports using the street name and town"
      end

      context "when there are no matching certificates, and the user clicks the link to get a new certificate" do
        before do
          fill_in "street_name", with: "Another Street"
          fill_in "town", with: "Somewhere Town"
          click_on "Find"
          click_on "get a new energy certificate"
        end

        it "shows the start page for the getting a new energy certificate service" do
          expect(page.find("h1")).to have_content "Getting a new energy certificate"
        end
      end

      context "when submitting the form with an empty street name" do
        before do
          fill_in "town", with: "Beauty Town"
          click_on "Find"
        end

        it "shows an error message to enter the street name", :aggregate_failures do
          expect(page).to have_content "Enter the street name"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the street name"
        end
      end

      context "when submitting the form with an empty town name" do
        before do
          fill_in "street_name", with: "1 street ave"
          click_on "Find"
        end

        it "shows an error message to enter the town name", :aggregate_failures do
          expect(page).to have_content "Enter the town or city"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the town or city"
        end
      end

      context "when submitting the form with empty street name and town" do
        before do
          click_on "Find"
        end

        it "shows error messages for both the missing street name and the missing town", :aggregate_failures do
          expect(page).to have_content "Enter the town"
          expect(page).to have_content "Enter the street name"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the town or city"
          expect(page).to have_link "Enter the street name"
        end
      end
    end

    context "with a certificate number" do
      before do
        click_on "find a certificate by using its certificate number"
      end

      context "when the certificate exists but has an unsupported schema" do
        before do
          fill_in "reference_number", with: "0000-0000-0000-0000-1112"
          click_on "Find"
        end

        it "does not show the link to download summary XML", :aggregate_failures do
          expect(page).not_to have_content "Summary XML"
          expect(page).not_to have_link "Download Summary XML"
        end
      end

      context "when the certificate does not exist" do
        before do
          fill_in "reference_number", with: "9900-0000-0000-0000-0099"
          click_on "Find"
        end

        it "shows an error page with the message saying no certificate matched", :aggregate_failures do
          expect(page).to have_content "A certificate was not found with this certificate number"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "A certificate was not found with this certificate number"
        end
      end
    end
  end

  context "when using the site in Welsh and performing a search on a postcode with non-domestic certificates against it" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Welsh (Cymraeg)"
      click_on "Dechreuwch nawr"
      find("#label-non-domestic").click
      click_on "Parhau"
      fill_in "postcode", with: "SW1A 2AA"
      click_button "Chwiliwch"
    end

    it "finds a certificate by postcode" do
      expect(page).to have_content "2 o dystysgrifau ac adroddiadau ar gyfer SW1A 2AA"
    end
  end
end
