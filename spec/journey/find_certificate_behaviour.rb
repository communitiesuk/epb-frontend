shared_examples "shows the Get a new energy certificate start page" do
  it "shows the Get a new energy certificate page" do
    expect(page.find("h1")).to have_content "Get a new energy certificate"
  end
end

shared_examples "a certificate search function" do |certificate_type:, property_type_label_element:, url_fragment:, find_by_street_and_town_text:, find_by_certificate_number_text:, search_by_postcode_header:, certificates_text_in_result_count:, text_in_street_and_town_results:, search_by_certificate_number_header:, link_text_in_postcode_search_results:|
  context "when searching for a #{certificate_type} certificate" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      find("##{property_type_label_element}").click
      click_on "Continue"
    end

    context "with a postcode for which certificates exist" do
      before do
        fill_in "postcode", with: "SW1A 2AA"
        click_button "Find"
      end

      it "shows existence of those certificates on the search results page" do
        expect(page).to have_content "2 #{certificates_text_in_result_count} for SW1A 2AA"
      end

      context "when selecting a known certificate from the results list" do
        before do
          click_on link_text_in_postcode_search_results, match: :first
        end

        it "shows the certificate with the expected header" do
          expect(page).to have_content "Energy performance certificate (EPC)"
        end
      end

      context "when selecting a certificate and then clicking on the back link" do
        before do
          click_on link_text_in_postcode_search_results, match: :first
          click_on "Back"
        end

        it "shows the postcode's search results page again" do
          expect(page).to have_current_path("/#{url_fragment}/search-by-postcode?postcode=SW1A+2AA")
        end
      end

      context "when selecting to get a new energy certificate" do
        before do
          click_on "get a new energy certificate"
        end

        include_examples "shows the Get a new energy certificate start page"
      end
    end

    context "with a postcode for which no certificates exist" do
      before do
        fill_in "postcode", with: "E1 4FF"
        click_on "Find"
      end

      context "when clicking on the link to get a new energy certificate" do
        before do
          click_link "get a new energy certificate"
        end

        include_examples "shows the Get a new energy certificate start page"
      end

      context "when clicking on the link to perform a search by postcode" do
        before do
          click_link "postcode"
        end

        it "shows the find EPC by postcode page" do
          expect(page.find("h1")).to have_content search_by_postcode_header
        end
      end

      context "when clicking on the link to perform a search by street and town" do
        before do
          click_link "street and town"
        end

        it "shows the find EPC by street and town page" do
          expect(page.find("h1")).to have_content "Find an energy performance certificate (EPC) by street and town"
        end
      end

      context "when clicking on the link to perform a search by certificate number" do
        before do
          click_link "certificate number"
        end

        it "shows the find EPC by certificate number page" do
          expect(page.find("h1")).to have_content search_by_certificate_number_header
        end
      end
    end

    context "with an empty postcode" do
      before do
        fill_in "postcode", with: ""
        click_on("Find")
      end

      it "shows an error page with validation including a link to the form element", :aggregate_failures do
        expect(page).to have_content "Enter a real postcode"
        expect(page).to have_content "There is a problem"
        expect(page).to have_link "Enter a real postcode"
      end
    end

    context "with an invalid postcode" do
      before do
        fill_in "postcode", with: "NOT A POSTCODE"
        click_on "Find"
      end

      it "shows an appropriate error message to enter a valid postcode" do
        expect(page).to have_content "Enter a real postcode"
      end
    end

    context "with a postcode followed by an SQL injection attempt" do
      before do
        visit "http://find-energy-certificate.local.gov.uk/#{url_fragment}/search-by-postcode?postcode=A0+0AA%27%3B+DROP+TABLE+assessments%3B"
        visit "http://find-energy-certificate.local.gov.uk/#{url_fragment}/search-by-postcode?postcode=SW1A+2AA"
      end

      it "shows assessments in a list of links to demonstrate that the SQL injection attempt has not worked" do
        expect(page).to have_content " #{certificates_text_in_result_count} for SW1A 2AA"
      end
    end

    context "with a certificate number (RRN)" do
      before do
        click_on find_by_certificate_number_text
      end

      context "when the certificate number exists" do
        before do
          fill_in "reference_number", with: "4567-6789-4567-6789-4567"
          click_on "Find"
        end

        it "shows the certificate page", :aggregate_failures do
          expect(page).to have_content "2 Marsham Street"
          expect(page).to have_content "Valid until"
          expect(page).to have_content "5 January 2030"
        end

        it "displays a backlink on the page" do
          expect(page).to have_content "Back"
        end
      end

      context "when the certificate number has a valid format but does not exist" do
        before do
          fill_in "reference_number", with: "9900-0000-0000-0000-0099"
          click_on "Find"
        end

        it "shows an error page with a message that no certificate was found with the number", :aggregate_failures do
          expect(page).to have_content "A certificate was not found with this certificate number"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "A certificate was not found with this certificate number"
        end
      end

      context "when the certificate number is too long" do
        before do
          fill_in "reference_number", with: "4567-6789-4567-6789-4567-1234"
          click_on "Find"
        end

        it "displays an error page with a validation link to the form element", :aggregate_failures do
          expect(page).to have_content "Enter a 20-digit certificate number"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter a 20-digit certificate number"
        end
      end
    end

    context "with street and town" do
      before do
        click_on find_by_street_and_town_text
      end

      context "when searching with a street and town that match known certificates" do
        before do
          fill_in "street_name", with: "1 Makeup Street"
          fill_in "town", with: "Beauty Town"
          click_on "Find"
        end

        it "shows a results page indicating matching results" do
          expect(page).to have_content text_in_street_and_town_results
        end
      end

      context "when searching with a street and town that do not match known certificates" do
        before do
          fill_in "street_name", with: "Madeup Street"
          fill_in "town", with: "Madeup Town"
          click_on "Find"
        end

        it "shows a message saying that no certificates were found for the given location" do
          expect(page).to have_content "A certificate was not found at this address."
        end
      end

      context "when searching with an empty street name" do
        before do
          fill_in "town", with: "Beauty Town"
          click_on "Find"
        end

        it "shows an error page with the message to enter a street", :aggregate_failures do
          expect(page).to have_content "Enter the street name"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the street name"
        end
      end

      context "when searching with an empty town name" do
        before do
          fill_in "street_name", with: "1 street ave"
          click_on "Find"
        end

        it "shows an error page with the message to enter a town", :aggregate_failures do
          expect(page).to have_content "Enter the town or city"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the town or city"
        end
      end

      context "when searching with empty street and town" do
        before do
          click_on "Find"
        end

        it "shows an error page with messages both to enter a street and enter a town", :aggregate_failures do
          expect(page).to have_content "Enter the town"
          expect(page).to have_content "Enter the street name"
          expect(page).to have_content "There is a problem"
          expect(page).to have_link "Enter the town or city"
          expect(page).to have_link "Enter the street name"
        end
      end

      context "when searching with a street and town that have no matching certificates and clicking the link to get a new certificate" do
        before do
          fill_in "street_name", with: "Madeup Street"
          fill_in "town", with: "Madeup Town"
          click_on "Find"
          click_on "get a new energy certificate"
        end

        include_examples "shows the Get a new energy certificate start page"
      end
    end
  end
end
