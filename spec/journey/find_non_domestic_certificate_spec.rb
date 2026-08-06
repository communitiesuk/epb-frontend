# frozen_string_literal: true

require_relative "./find_certificate_behaviour"

describe "Journey::FindNonDomesticCertificate", :journey, type: :feature do
  it_behaves_like "a certificate search function", certificate_type: "non-domestic",
                                                   property_type_label: "A non-domestic property",
                                                   url_fragment: "find-a-non-domestic-certificate",
                                                   find_a_postcode_text: "find a postcode on Royal Mail’s postcode finder",
                                                   find_by_street_and_town_text: "find energy certificates and reports using the street name and town",
                                                   find_by_street_and_town_header: "What is the address?",
                                                   find_by_certificate_number_text: "find a certificate by using its certificate number",
                                                   search_by_postcode_header: "What is the postcode?",
                                                   search_by_certificate_number_header: "What is the certificate or report number?",
                                                   certificate_number_label: "Enter a certificate or report number",
                                                   certificates_text_in_result_count: "certificates and reports",
                                                   text_in_street_and_town_results: "certificates and reports for",
                                                   link_text_in_postcode_search_results: "CEPC"

  context "when using the site in Welsh and performing a search on a postcode with non-domestic certificates against it" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_link "Welsh (Cymraeg)"
      click_link "Dechrau nawr"
      within_fieldset "Tystysgrif i ba fath o eiddo yw hi?" do
        choose "Eiddo annomestig", allow_label_click: true
      end
      click_button "Parhau"
      fill_in "Rhowch y cod post", with: "SW1A 2AA"
      click_button "Chwiliwch"
    end

    it "finds a certificate by postcode" do
      expect(page).to have_content "2 o dystysgrifau ac adroddiadau ar gyfer SW1A 2AA"
    end
  end
end
