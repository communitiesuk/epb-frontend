# frozen_string_literal: true

describe "Journey::FindDomesticCertificate", type: :feature, journey: true do
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
          err: %i[child out],
        ],
      )
    @process_id = process.pid

    unless process.readline.include?("port=9393")
    end
  end

  after(:all) { Process.kill("KILL", @process_id) }

  describe "when searching for a domestic certificate by postcode" do
    it "finds a certificate by postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_button "Find"
      expect(page).to have_content "2 EPCs for SW1A 2AA"
    end

    it "displays the found postcode results and clicks through to Getting an Energy Certificate" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      click_on "get a new energy certificate"
      expect(page).to have_content "Getting a new energy certificate"
    end

    it "displays no postcode results and clicks through to Getting an Energy Certificate" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_link "get a new energy certificate"
      expect(page).to have_content "Getting a new energy certificate"
    end

    it "displays no postcode results and clicks through to search by postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_link "postcode"
      expect(
        page,
      ).to have_content "Find an energy performance certificate (EPC) by postcode"
    end

    it "displays no postcode results and clicks through to search by street and town" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_link "street and town"
      expect(
        page,
      ).to have_content "Find an energy performance certificate (EPC) by street and town"
    end

    it "displays no postcode results and clicks through to search by certificate number" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_link "certificate number"
      expect(
        page,
      ).to have_content "Find an energy performance certificate (EPC) by certificate number"
    end

    describe "viewing in Welsh" do
      it "finds a certificate by postcode" do
        visit "http://find-energy-certificate.local.gov.uk:9393"
        click_on "Welsh (Cymraeg)"
        click_on "Dechreuwch nawr"
        find("#label-domestic").click
        click_on "Parhau"
        fill_in "postcode", with: "SW1A 2AA"
        click_button "Chwiliwch"
        expect(page).to have_content "2 EPCs ar gyfer SW1A 2AA"
      end
    end

    it "displays an error message and summary when entering an empty postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: ""
      click_on("Find")
      expect(page).to have_content "Enter a real postcode"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter a real postcode"
    end

    it "displays an error message when you don't select a property type" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      click_on "Continue"
      expect(page).to have_content "Please select a type of property"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Please select a type of property"
    end

    it "displays an error message when entering an invalid postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "NOT A POSTCODE"
      click_on "Find"
      expect(page).to have_content "Enter a real postcode"

    end
  end

  describe "when searching for a domestic certificate by RRN" do
    it "redirects directly to the certificate page when entering a valid certificate number" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC by using its certificate number"
      fill_in "reference_number", with: "4567-6789-4567-6789-4567"
      click_on "Find"
      expect(page).to have_content "2 Marsham Street"
      expect(page).to have_content "Valid until"
      expect(page).to have_content "5 January 2030"
    end

    it "displays an error message when entering a certificate value of more than 20 chars" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC by using its certificate number"
      click_on "Find"
      expect(page).to have_content "Enter a 20-digit certificate number"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter a 20-digit certificate number"
    end

    it "displays an error message when entering a certificate value that is not found" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC by using its certificate number"
      fill_in "reference_number", with: "9900-0000-0000-0000-0099"
      click_on "Find"
      expect(
        page,
      ).to have_content "A certificate was not found with this certificate number"
      expect(page).to have_content "There is a problem"
      expect(
        page,
      ).to have_link "A certificate was not found with this certificate number"
    end
  end

  describe "when searching for a domestic certificate by street name and town" do
    it "displays an error message when entering an empty street name" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC using the street name and town"
      fill_in "town", with: "Beauty Town"
      click_on "Find"
      expect(page).to have_content "Enter the street name"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter the street name"
    end

    it "displays an error message when entering an empty town name" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC using the street name and town"
      fill_in "street_name", with: "1 street ave"
      click_on "Find"
      expect(page).to have_content "Enter the town or city"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter the town or city"
    end

    it "displays an error message when entering an empty town and street name" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC using the street name and town"
      click_on "Find"
      expect(page).to have_content "Enter the town"
      expect(page).to have_content "Enter the street name"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter the town or city"
      expect(page).to have_link "Enter the street name"
    end

    it "displays the find a certificate page heading when entering a valid query" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC using the street name and town"
      fill_in "street_name", with: "1 Makeup Street"
      fill_in "town", with: "Beauty Town"
      click_on "Find"
      expect(page).to have_content "of 3 results matching"
    end

    it "displays the error message when searching for a certificate that doesnt exist" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC using the street name and town"
      fill_in "street_name", with: "Madeup Street"
      fill_in "town", with: "Madeup Town"
      click_on "Find"
      expect(
        page,
      ).to have_content "A certificate was not found at this address."
    end

    it "displays no street search results and clicks through to Getting an Energy Certificate" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      click_on "find an EPC using the street name and town"
      fill_in "street_name", with: "Madeup Street"
      fill_in "town", with: "Madeup Town"
      click_on "Find"
      click_on "get a new energy certificate"
      expect(page).to have_content "Getting a new energy certificate"
    end
  end

  describe "when searching for a certificate via a provided link" do
    context "and the certificate is cancelled or not for issue" do
      it "redirects users to the main page" do
        visit "http://find-energy-certificate.local.gov.uk:9393/energy-certificate/0000-0000-0000-0000-0666"
        within("main") { click_link "Find an energy certificate" }
        expect(page).to have_content "Find an energy certificate"
      end
    end
  end
end
