# frozen_string_literal: true

require_relative "./find_certificate_behaviour"

describe "Journey::FindDomesticCertificate", type: :feature, journey: true do
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

  it_behaves_like "a certificate search function", certificate_type: "domestic",
                                                   property_type_label_element: "label-domestic",
                                                   url_fragment: "find-a-certificate",
                                                   find_a_postcode_text: "find a postcode on Royal Mail’s postcode finder",
                                                   find_by_street_and_town_text: "find an EPC using the street name and town",
                                                   find_by_certificate_number_text: "find an EPC by using its certificate number",
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
        expect(page).to have_link "Find an energy certificate"
        within("main") { click_link "Find an energy certificate" }
        expect(page).to have_content "Find an energy certificate"
      end
    end
  end

  context "when clicking continue without selecting type of property" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      click_on "Continue"
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
      click_on "Welsh (Cymraeg)"
      click_on "Dechreuwch nawr"
      find("#label-domestic").click
      click_on "Parhau"
      fill_in "postcode", with: "SW1A 2AA"
      click_button "Chwiliwch"
    end

    it "shows the expected results page for the postcode, in Welsh" do
      expect(page).to have_content "2 EPCs ar gyfer SW1A 2AA"
    end
  end
end
