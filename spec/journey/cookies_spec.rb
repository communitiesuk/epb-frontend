describe "using cookies page", type: :feature, journey: true do
  let(:finding_domain) do
    "http://find-energy-certificate.local.gov.uk:9393"
  end

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

  context "when changing cookie settings on the cookies page" do
    before do
      visit finding_domain
      click_on "Start now"
      click_on "Cookies"
      find("#cookies-setting-false").click
      click_on "Save settings"
    end

    it "shows a notification banner link to the start of the service", aggregate_failures: true do
      expect(page).to have_link "Go back to Find an energy certificate", href: "/"
    end
  end
end
