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

  it "finds a certificate by postcode" do
    visit "http://find-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    fill_in "postcode", with: "SW1A 2AA"
    click_button "Find"
    expect(page).to have_content "2 EPCs for SW1A 2AA"
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

  it "displays an error message when entering an empty postcode" do
    visit "http://find-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    fill_in "postcode", with: ""
    click_on("Find")
    expect(page).to have_content "Enter a real postcode"
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

  it "displays the find a certificate page heading when entering a valid postcode" do
    visit "http://find-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    fill_in "postcode", with: "SW1A 2AA"
    click_on "Find"
    expect(page).to have_content "2 EPCs for SW1A 2AA"
  end

  it "redirects directly to the certificate page when entering a valid certificate number" do
    visit "http://find-energy-certificate.local.gov.uk:9393"
    click_on "Start now"
    find("#label-domestic").click
    click_on "Continue"
    click_on "find an EPC by using its certificate number"
    fill_in "reference_number", with: "4567-6789-4567-6789-4567"
    click_on "Find"
    expect(page).to have_content "2 Marsham Street"
    expect(page).to have_content "Valid until 5 January 2030"
  end

  # it "displays an error message when entering an empty street name" do
  #   visit "http://find-energy-certificate.local.gov.uk:9393"
  #   click_on "Start now"
  #   find("#label-domestic").click
  #   click_on "Continue"
  #   click_on "find an EPC using the street name and town"
  #   fill_in "town", with: "Beauty Town"
  #   click_on "Find"
  #   expect(page).to have_content "Enter the street name"
  # end

  # it "displays an error message when entering an empty town" do
  #   visit "http://find-energy-certificate.local.gov.uk:9393"
  #   click_on "Start now"
  #   find("#label-domestic").click
  #   click_on "Continue"
  #   click_on "find an EPC using the street name and town"
  #   fill_in "street_name", with: "1 Makeup Street"
  #   click_on "Find"
  #   expect(page).to have_content "Enter the town"
  # end

  # it "displays an error message when entering an empty town and street name" do
  #   visit "http://find-energy-certificate.local.gov.uk:9393"
  #   click_on "Start now"
  #   find("#label-domestic").click
  #   click_on "Continue"
  #   click_on "find an EPC using the street name and town"
  #   click_on "Find"
  #   expect(page).to have_content "Enter the town"
  #   expect(page).to have_content "Enter the street name"
  # end

  # it "displays the find a certificate page heading when entering a valid query" do
  #   visit "http://find-energy-certificate.local.gov.uk:9393"
  #   click_on "Start now"
  #   find("#label-domestic").click
  #   click_on "Continue"
  #   click_on "find an EPC using the street name and town"
  #   fill_in "street_name", with: "1 Makeup Street"
  #   fill_in "town", with: "Beauty Town"
  #   click_on "Find"
  #   expect(page).to have_content "of 3 results matching"
  # end

  # it "displays the error message when searching for a certificate that doesnt exist" do
  #   visit "http://find-energy-certificate.local.gov.uk:9393"
  #   click_on "Start now"
  #   find("#label-domestic").click
  #   click_on "Continue"
  #   click_on "find an EPC using the street name and town"
  #   fill_in "street_name", with: "Madeup Street"
  #   fill_in "town", with: "Madeup Town"
  #   click_on "Find"
  #   expect(page).to have_content "A certificate was not found at this address."
  # end
end
