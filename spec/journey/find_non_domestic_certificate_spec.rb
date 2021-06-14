# frozen_string_literal: true

describe "Journey::FindNonDomesticCertificate", type: :feature, journey: true do
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
    @process_id = process.pid

    nil unless process.readline.include?("port=9393")
  end

  after(:all) { Process.kill("KILL", @process_id) }

  describe "when searching for a non-domestic certificate by postcode" do
    it "finds a certificate by postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_button "Find"
      expect(page).to have_content "2 certificates and reports for SW1A 2AA"
    end

    it "displays the found postcode results and clicks through to Getting an Energy Certificate" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      click_on "get a new energy certificate"
      expect(page).to have_content "Getting a new energy certificate"
    end

    it "displays no postcode results and clicks through to Getting an Energy Certificate" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_on "get a new energy certificate"
      expect(page).to have_content "Getting a new energy certificate"
    end

    it "displays no postcode results and clicks through to search by postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_link "postcode"
      expect(
        page,
      ).to have_content "Find energy certificates and reports by postcode"
    end

    it "displays no postcode results and clicks through to search by street and town" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
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
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "E1 4FF"
      click_on "Find"
      click_link "certificate number"
      expect(
        page,
      ).to have_content "Find energy certificates and reports by their number"
    end

    describe "viewing in Welsh" do
      it "finds a certificate by postcode" do
        visit "http://find-energy-certificate.local.gov.uk:9393"
        click_on "Welsh (Cymraeg)"
        click_on "Dechreuwch nawr"
        find("#label-non-domestic").click
        click_on "Parhau"
        fill_in "postcode", with: "SW1A 2AA"
        click_button "Chwiliwch"
        expect(
          page,
        ).to have_content "2 o dystysgrifau ac adroddiadau ar gyfer SW1A 2AA"
      end
    end

    it "displays an error message when entering an empty postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: ""
      click_on("Find")
      expect(page).to have_content "Enter a real postcode"
    end

    it "displays an error message when entering an invalid postcode" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "NOT A POSTCODE"
      click_on "Find"
      expect(page).to have_content "Enter a real postcode"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter a real postcode"
    end
  end

  describe "when searching for a non-domestic certificate by street name and town" do
    it "displays no street search results and clicks through to Getting an Energy Certificate" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      click_on "find energy certificates and reports using the street name and town"
      fill_in "street_name", with: "Another Street"
      fill_in "town", with: "Somewhere Town"
      click_on "Find"
      click_on "get a new energy certificate"
      expect(page).to have_content "Getting a new energy certificate"
    end

    it "displays an error message when entering an empty street name" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      click_on "find energy certificates and reports using the street name and town"
      fill_in "town", with: "Beauty Town"
      click_on "Find"
      expect(page).to have_content "Enter the street name"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter the street name"
    end

    it "displays an error message when entering an empty town name" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      click_on "find energy certificates and reports using the street name and town"
      fill_in "street_name", with: "1 street ave"
      click_on "Find"
      expect(page).to have_content "Enter the town or city"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter the town or city"
    end

    it "displays an error message when entering an empty town and street name" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      click_on "find energy certificates and reports using the street name and town"
      click_on "Find"

      expect(page).to have_content "Enter the town"
      expect(page).to have_content "Enter the street name"
      expect(page).to have_content "There is a problem"
      expect(page).to have_link "Enter the town or city"
      expect(page).to have_link "Enter the street name"
    end
  end

  describe "when searching for an unsupported non domestic certificate by RRN" do
    it "redirects directly to the certificate page and does not shows a summary xml link" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      click_on "find a certificate by using its certificate number"
      fill_in "reference_number", with: "0000-0000-0000-0000-1112"
      click_on "Find"
      expect(page).to_not have_content "Summary XML"
      expect(page).to_not have_link "Download Summary XML"
    end

    it "displays an error message when entering a certificate value that is not found" do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      click_on "find a certificate by using its certificate number"
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
end
