describe "view Service Performance page", :journey, type: :feature do
  context "when viewing the service performance page" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_link "Start now"
      click_link "Service performance"
    end

    it "shows six accordions" do
      expect(page.all(".govuk-accordion").length).to eq 6
    end
  end

  context "when viewing the service performance page in Welsh" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_link "Welsh (Cymraeg)"
      click_link "Dechrau nawr"
      click_link "Perfformiad y gwasanaeth"
    end

    it "shows six accordions" do
      expect(page.all(".govuk-accordion").length).to eq 6
    end
  end
end
