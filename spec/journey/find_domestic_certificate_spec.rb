# frozen_string_literal: true

require_relative "./find_certificate_behaviour"

describe "Journey::FindDomesticCertificate", :journey, type: :feature do
  it_behaves_like "a certificate search function", certificate_type: "domestic",
                                                   property_type_label: "A domestic property",
                                                   url_fragment: "find-a-certificate",
                                                   find_a_postcode_text: "find a postcode on Royal Mail’s postcode finder",
                                                   find_by_street_and_town_text: "find an energy certificate using the street name and town",
                                                   find_by_street_and_town_header: "What is the address?",
                                                   find_by_certificate_number_text: "find an energy certificate by using its certificate number",
                                                   certificate_number_label: "Enter a certificate number",
                                                   search_by_postcode_header: "What is the postcode?",
                                                   search_by_certificate_number_header: "What is the certificate number?",
                                                   certificates_text_in_result_count: "EPCs",
                                                   text_in_street_and_town_results: "result matching",
                                                   link_text_in_postcode_search_results: "2 Marsham Street, London, SW1A 2AA"

  context "when accessing a certificate page via a provided link" do
    context "with a certificate that exists" do
      before do
        visit "http://find-energy-certificate.local.gov.uk:9393/energy-certificate/4567-6789-4567-6789-4568"
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
        expect(page).to have_link "check if there is a new certificate"
        within("main") { click_link "check if there is a new certificate" }
        expect(page).to have_content "Find an energy certificate"
      end
    end
  end

  context "when clicking continue without selecting type of property" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_link "Start now"
      click_button "Continue"
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
      click_link "Welsh (Cymraeg)"
      click_link "Dechrau nawr"
      within_fieldset "Tystysgrif i ba fath o eiddo yw hi?" do
        choose "Eiddo domestig", allow_label_click: true
      end
      click_button "Parhau"
      fill_in "Rhowch y cod post", with: "SW1A 2AA"
      click_button "Chwiliwch"
    end

    it "shows the expected results page for the postcode, in Welsh" do
      expect(page).to have_content "2 EPCs ar gyfer SW1A 2AA"
    end
  end
end
