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
    visit "/find-a-certificate"
    click_on "Start now"
    fill_in "postcode", with: "SW1A 2AA"
    click_button "Find"
    expect(page).to have_content "1-2 of 2 results matching SW1A 2AA"
  end

  describe "viewing in Welsh" do
    it "finds a certificate by postcode" do
      visit "/find-a-certificate"
      click_on "Welsh (Cymraeg)"
      click_on "Welsh: Start now"
      fill_in "postcode", with: "SW1A 2AA"
      click_button "Welsh: Find"
      expect(page).to have_content "Welsh: 1-2 of 2 results matching SW1A 2AA"
    end
  end

  it "displays an error message when entering an empty postcode" do
    visit "/find-a-certificate"
    click_on "Start now"
    fill_in "postcode", with: ""
    click_on("Find")
    expect(page).to have_content "Enter a real postcode"
  end

  it "displays an error message when entering an invalid postcode" do
    visit "/find-a-certificate"
    click_on "Start now"
    fill_in "postcode", with: "NOT A POSTCODE"
    click_on "Find"
    expect(page).to have_content "Enter a real postcode"
  end

  it "displays the find a certificate page heading when entering a valid postcode" do
    visit "/find-a-certificate"
    click_on "Start now"
    fill_in "postcode", with: "SW1A 2AA"
    click_on "Find"
    expect(page).to have_content "of 2 results matching"
  end

  it "redirects directly to the certificate page when entering a valid certificate reference number" do
    visit "/find-a-certificate"
    click_on "Start now"
    click_on "certificate by reference"
    fill_in "reference_number", with: "4567-6789-4567-6789-4567"
    click_on "Find"
    expect(page).to have_content "2 Marsham Street"
    expect(page).to have_content "Valid until 5 January 2030"
  end

  it "displays an error message when entering an empty street name" do
    visit "/find-a-certificate"
    click_on "Start now"
    click_on "find an EPC using the street name and town"
    fill_in "town", with: "Beauty Town"
    click_on "Find"
    expect(page).to have_content "Enter the street name"
  end

  it "displays an error message when entering an empty town" do
    visit "/find-a-certificate"
    click_on "Start now"
    click_on "find an EPC using the street name and town"
    fill_in "street_name", with: "1 Makeup Street"
    click_on "Find"
    expect(page).to have_content "Enter the town"
  end

  it "displays an error message when entering an empty town and street name" do
    visit "/find-a-certificate"
    click_on "Start now"
    click_on "find an EPC using the street name and town"
    click_on "Find"
    expect(page).to have_content "Enter the town"
    expect(page).to have_content "Enter the street name"
  end

  it "displays the find a certificate page heading when entering a valid query" do
    visit "/find-a-certificate"
    click_on "Start now"
    click_on "find an EPC using the street name and town"
    fill_in "street_name", with: "1 Makeup Street"
    fill_in "town", with: "Beauty Town"
    click_on "Find"
    expect(page).to have_content "of 3 results matching"
  end

  it "displays the error message when searching for a certificate that doesnt exist" do
    visit "/find-a-certificate"
    click_on "Start now"
    click_on "find an EPC using the street name and town"
    fill_in "street_name", with: "Madeup Street"
    fill_in "town", with: "Madeup Town"
    click_on "Find"
    expect(page).to have_content "A certificate was not found at this address."
    click_on "Find an assessor"

    expect(
      page,
    ).to have_content "Getting a new Energy Performance Certificate (EPC)"
  end
end
