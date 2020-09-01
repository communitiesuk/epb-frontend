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

  it "finds an assessor by postcode" do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in "postcode", with: "SW1A 2AA"
    click_on "Find"
  end

  it "finds an assessor by postcode in Welsh" do
    visit "/find-an-assessor"
    click_on "Welsh (Cymraeg)"
    click_on "Welsh: Start now"
    fill_in "postcode", with: "SW1A 2AA"
    click_on "Welsh: Find"
  end

  it "displays an error message when entering an empty postcode" do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in "postcode", with: ""
    click_on "Find"
    expect(page).to have_content "Enter a real postcode"
  end

  it "displays an error message when entering an invalid postcode" do
    visit "/find-an-assessor"
    click_on "Start now"
    fill_in "postcode", with: "NOT A POSTCODE"
    click_on "Find"
    expect(page).to have_content "Enter a real postcode"
  end

  context "when entering a valid postcode" do
    it "displays the find an assessor page heading" do
      visit "/find-an-assessor"
      click_on "Start now"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      expect(
        page,
      ).to have_content "7 assessors in order of distance from SW1A 2AA"
    end

    it "displays accreditation scheme contact details for the first assessor" do
      visit "/find-an-assessor"
      click_on "Start now"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find("span", text: "More information", match: :first).click
      expect(page).to have_content "Contact details for CIBSE:"
      expect(page).to have_content "epc@cibsecertification.org"
      expect(page).to have_content "020 8772 3649"
    end

    it "displays no longer accredited text for unaccredited scheme" do
      visit "/find-an-assessor"
      click_on "Start now"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find_all("span", text: "More information")[4].click
      expect(page).to have_content "EPB 4 U is no longer accredited."
    end
  end

  it "displays an error message when entering an empty name" do
    visit "/find-an-assessor"
    click_on "Start now"
    click_on "find an assessor by name"
    click_on "Search"
    expect(
      page,
    ).to have_content "Enter the assessor’s full name, including their first name and last name"
  end

  it "displays an assessor when searched for one that does exist" do
    visit "/find-an-assessor"
    click_on "Start now"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon"
    click_on "Search"
    expect(
      page,
    ).to have_content "Enter the assessor’s full name, including their first name and last name"
  end

  it "displays an assessor when searched for one that does exist" do
    visit "/find-an-assessor"
    click_on "Start now"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon Name"
    click_on "Search"
    expect(page).to have_content "7 results, found by the name Supercommon Name"
  end

  it "displays accreditation scheme contact details for an existing assessor by name" do
    visit "/find-an-assessor"
    click_on "Start now"
    click_on "find an assessor by name"
    fill_in "name", with: "Supercommon Name"
    click_on "Search"
    find_all("span", text: "More information")[2].click
    expect(page).to have_content "Contact details for ECMK:"
    expect(page).to have_content "info@ecmk.co.uk"
    expect(page).to have_content "0333 123 1418"
  end

  context "when finding a non-domestic assessor by postcode" do
    it "finds a non-domestic assessor" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
    end

    it "displays an error message when entering an empty postcode" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: ""
      click_on "Find"
      expect(page).to have_content "Enter a real postcode"
    end

    it "displays an error message when entering an invalid postcode" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "NOT A POSTCODE"
      click_on "Find"
      expect(page).to have_content "Enter a real postcode"
    end

    it "displays the find a non domestic assessor page heading when entering a valid postcode " do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      expect(
        page,
      ).to have_content "7 assessors in order of distance from SW1A 2AA"
    end

    it "displays accreditation scheme contact details for the first assessor" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find_all("span", text: "More information")[1].click
      expect(page).to have_content "Contact details for Stroma:"
      expect(page).to have_content "Email: certification@stroma.com"
      expect(page).to have_content "Telephone: 0845 621 11 11"
    end

    it "displays no longer accredited text for unaccredited scheme" do
      visit "/find-an-assessor"
      click_on "find a non domestic assessor"
      fill_in "postcode", with: "SW1A 2AA"
      click_on "Find"
      find_all("span", text: "More information")[4].click
      expect(page).to have_content "EPB 4 U is no longer accredited."
    end
  end
end
