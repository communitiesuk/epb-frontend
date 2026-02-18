# frozen_string_literal: true

require_relative "./find_certificate_behaviour"

describe "Journey::FindNonDomesticCertificate", :journey, type: :feature do
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

    # Wait until the Puma server has started up before commencing tests
    loop do
      break if process.readline.include?("Listening on http://127.0.0.1:9393")
    end
  end

  after(:all) { Process.kill("KILL", process_id) if process_id }

  it_behaves_like "a certificate search function", certificate_type: "non-domestic",
                                                   property_type_label_element: "label-non-domestic",
                                                   url_fragment: "find-a-non-domestic-certificate",
                                                   find_a_postcode_text: "find a postcode on Royal Mail’s postcode finder",
                                                   find_by_street_and_town_text: "find energy certificates and reports using the street name and town",
                                                   find_by_street_and_town_header: "What is the address?",
                                                   find_by_certificate_number_text: "find a certificate by using its certificate number",
                                                   search_by_postcode_header: "What is the postcode?",
                                                   search_by_certificate_number_header: "What is the certificate or report number?",
                                                   certificates_text_in_result_count: "certificates and reports",
                                                   text_in_street_and_town_results: "certificates and reports for",
                                                   link_text_in_postcode_search_results: "CEPC"

  context "when using the site in Welsh and performing a search on a postcode with non-domestic certificates against it" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Welsh (Cymraeg)"
      click_on "Dechrau nawr"
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
