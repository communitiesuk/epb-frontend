# frozen_string_literal: true

describe "Journey::CookiesOnOurService", :journey, type: :feature do
  process_id = nil

  before(:all) do
    process = IO.popen(["rackup", "config_test.ru", "-q", "-o", "127.0.0.1", "-p", "9393", { err: %i[child out] }])
    process_id = process.pid
    loop { break if process.readline.include?("Listening on http://127.0.0.1:9393") }
  end

  after(:all) { Process.kill("KILL", process_id) if process_id }

  before do
    # Clear the cookies
    Capybara.reset_sessions!
  end

  shared_examples "a cookie choices page" do
    let(:analytics_script_host) { "https://www.googletagmanager.com/" }

    it "shows a user as opted into cookies by default" do
      visit url
      within_fieldset "Cookies on our service" do
        expect(page).to have_checked_field "Use cookies that measure my website use", visible: :all
      end
      expect(page).to have_css %(script[src^="#{analytics_script_host}"]), visible: :all
    end

    it "allows a user to opt out of cookies and retains this setting" do
      visit url
      within_fieldset "Cookies on our service" do
        choose "Do not use cookies that measure my website use", allow_label_click: true
      end
      click_button "Save settings"
      expect(page).to have_css "[role=alert]", text: "You’ve set your cookie preferences"
      expect(page).to have_checked_field "Do not use cookies that measure my website use", visible: :all
      expect(page).to have_no_css %(script[src^="#{analytics_script_host}"]), visible: :all

      click_link home_link_text, match: :first
      expect(page).to have_no_css %(script[src^="#{analytics_script_host}"]), visible: :all
      expect(page).to have_no_text banner_title

      click_link "Cookies"
      within_fieldset "Cookies on our service" do
        expect(page).to have_checked_field "Do not use cookies that measure my website use", visible: :all
      end
    end

    it "allows a user to opt into cookies and retains this setting" do
      visit url
      within_fieldset "Cookies on our service" do
        choose "Use cookies that measure my website use", allow_label_click: true
      end
      click_button "Save settings"
      expect(page).to have_css "[role=alert]", text: "You’ve set your cookie preferences"
      expect(page).to have_checked_field "Use cookies that measure my website use", visible: :all
      expect(page).to have_css %(script[src^="#{analytics_script_host}"]), visible: :all

      click_link home_link_text, match: :first
      expect(page).to have_css %(script[src^="#{analytics_script_host}"]), visible: :all
      expect(page).to have_no_text banner_title

      click_link "Cookies"
      within_fieldset "Cookies on our service" do
        choose "Use cookies that measure my website use", allow_label_click: true, visible: :all
      end
    end

    it "removes existing _ga cookies when opting out" do
      visit url
      page.driver.browser.manage.add_cookie(
        name: "_ga",
        value: "foo",
        path: "/",
        domain: URI(page.current_url).host,
      )
      ga_cookies = page.driver.browser.manage.all_cookies.filter { it[:name].start_with?("_ga") }
      expect(ga_cookies.length).to be_positive

      within_fieldset "Cookies on our service" do
        choose "Do not use cookies that measure my website use", allow_label_click: true
      end
      click_button "Save settings"

      ga_cookies = page.driver.browser.manage.all_cookies.filter { it[:name].start_with?("_ga") }
      expect(ga_cookies.length).to be_zero
    end
  end

  it_behaves_like "a cookie choices page" do
    let(:url) { "http://find-energy-certificate.local.gov.uk:9393/cookies" }
    let(:banner_title) { "Cookies on Find an energy certificate" }
    let(:home_link_text) { "Find an energy certificate" }
  end

  it_behaves_like "a cookie choices page" do
    let(:url) { "http://getting-new-energy-certificate.local.gov.uk:9393/cookies" }
    let(:banner_title) { "Cookies on Get a new energy certificate" }
    let(:home_link_text) { "Get a new energy certificate" }
  end
end
