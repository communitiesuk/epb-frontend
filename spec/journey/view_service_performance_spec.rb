describe "view Service Performance page", :journey, type: :feature do
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

  context "when viewing the service performance page" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Start now"
      click_on "Service performance"
    end

    it "shows six accordions" do
      expect(page.all(".govuk-accordion").length).to eq 6
    end
  end

  context "when viewing the service performance page in Welsh" do
    before do
      visit "http://find-energy-certificate.local.gov.uk:9393"
      click_on "Welsh (Cymraeg)"
      click_on "Dechreuwch nawr"
      click_on "Perfformiad y gwasanaeth"
    end

    it "shows six accordions" do
      expect(page.all(".govuk-accordion").length).to eq 6
    end
  end
end
