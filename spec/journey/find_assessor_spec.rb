# frozen_string_literal: true

describe "Journey::FindAssessor", type: :feature, journey: true do
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

  it "finds a domestic assessor by postcode" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    fill_in "postcode", with: "SW1A 2AA"
    click_on "Find"
  end

  it "displays an error message when entering an empty postcode" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    fill_in "postcode", with: ""
    click_on "Find"
    expect(page).to have_content "Enter a real postcode"
  end

  it "displays an error message when you don't select a property type" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    click_on "Continue"
    expect(page).to have_content "Please select a type of property"
  end

  it "displays an error message when entering an invalid postcode" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    fill_in "postcode", with: "NOT A POSTCODE"
    click_on "Find"
    expect(page).to have_content "Enter a real postcode"
  end

  context "when entering a valid postcode" do
    it "displays the find an assessor page heading" do
      visit "http://getting-new-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      expect(
        page,
      ).to have_content "7 assessors in order of distance from SW1A 2AA"
    end

    it "displays to search again, enter the postcode of the property" do
      visit "http://getting-new-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      expect(
        page,
      ).to have_content "To search again, enter the postcode of the property"
    end

    it "displays accreditation scheme contact details for the first assessor" do
      visit "http://getting-new-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find("span", text: "More information", match: :first).click
      expect(
        page,
      ).to have_content "Contact details for CIBSE Certification Limited:"
      expect(page).to have_content "epc@cibsecertification.org"
      expect(page).to have_content "020 8772 3649"
    end

    it "displays no longer accredited text for unaccredited scheme" do
      visit "http://getting-new-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find_all("span", text: "More information")[4].click
      expect(page).to have_content "EPB 4 U is no longer accredited."
    end
  end

  it "displays an error message when entering an empty name" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    click_on "find an assessor by name"
    click_on "Search"
    expect(page).to have_content "Enter the first and last name of the assessor"
  end

  it "displays an assessor when searched for one that does exist" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon"
    click_on "Search"
    expect(page).to have_content "Enter the first and last name of the assessor"
  end

  it "displays 'Not Supplied' when an assessor has not supplied an email address or phone number" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon Name"
    click_on "Search"
    expect(page).to have_content "Email Not Supplied"
    expect(page).to have_content "Telephone Not Supplied"
  end

  it "displays an assessor when searched for one that does exist" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon Name"
    click_on "Search"
    expect(page).to have_content "8 results for the name Supercommon Name"
  end

  it "displays accreditation scheme contact details for an existing assessor by name" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    expect(page).to have_content "What type of property is the certificate for?"
    find("#label-domestic").click
    click_on "Continue"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon Name"
    click_on "Search"
    find_all("span", text: "More information")[2].click
    expect(page).to have_content "Contact details for ECMK:"
    expect(page).to have_content "info@ecmk.co.uk"
    expect(page).to have_content "0333 123 1418"
  end

  it "will allow a user to go back to the getting-new-energy-certificate page" do
    visit "http://getting-new-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    expect(page).to have_content "What type of property is the certificate for?"
    click_link "Back"
    expect(page).to have_content "Getting a new energy certificate"
  end

  context "when finding a non-domestic assessor by postcode" do
    xit "finds a non-domestic assessor" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
    end

    xit "displays an error message when entering an empty postcode" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: ""
      click_on "Find"
      expect(page).to have_content "Enter a real postcode"
    end

    xit "displays an error message when entering an invalid postcode" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "NOT A POSTCODE"
      click_on "Find"
      expect(page).to have_content "Enter a real postcode"
    end

    it "displays to search again, enter the postcode of the property" do
      visit "http://getting-new-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("#label-non-domestic").click
      click_on "Continue"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      expect(
        page,
      ).to have_content "To search again, enter the postcode of the property"
    end

    xit "displays the find a non domestic assessor page heading when entering a valid postcode " do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      expect(
        page,
      ).to have_content "7 assessors in order of distance from SW1A 2AA"
    end

    xit "displays accreditation scheme contact details for the first assessor" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find_all("span", text: "More information")[1].click
      expect(
        page,
      ).to have_content "Contact details for Stroma Certification Ltd:"
      expect(page).to have_content "Email: certification@stroma.com"
      expect(page).to have_content "Telephone: 0330 124 9660"
    end

    xit "displays no longer accredited text for unaccredited scheme" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find_all("span", text: "More information")[4].click
      expect(page).to have_content "EPB 4 U is no longer accredited."
    end
  end
end
