# frozen_string_literal: true

describe "Journey::CookieBanner", :journey, type: :feature do
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

  shared_examples "there is a cookie banner" do
    let(:banner_accept) { "You’ve accepted analytics cookies" }
    let(:banner_reject) { "You’ve rejected analytics cookies" }
    let(:analytics_script_host) { "https://www.googletagmanager.com/" }

    it "opts into analytics cookies by default" do
      visit url
      expect(page).to have_css %(script[src^="#{analytics_script_host}"]), visible: :all
    end

    it "shows the cookie banner, you can accept cookies and the banner no longer shows" do
      visit url
      expect(page).to have_text banner_title
      expect(page).to have_link "View cookies", href: "/cookies"

      click_button "Accept analytics cookies"
      expect(page).to have_no_text banner_title
      expect(page).to have_css "[role=alert]", text: banner_accept

      click_button "Hide cookie message"
      expect(page).to have_no_text banner_accept

      click_link "Start now"
      expect(page).to have_css "h1", text: "What type of property is the certificate for?"
      expect(page).to have_no_text banner_title
      expect(page).to have_css %(script[src^="#{analytics_script_host}"]), visible: :all

      click_link "Cookies"
      within_fieldset "Cookies on our service" do
        expect(page).to have_checked_field "Use cookies that measure my website use", visible: :all
      end
    end

    it "shows the cookie banner, you can reject cookies and the banner no longer shows" do
      visit url
      expect(page).to have_text banner_title
      expect(page).to have_link "View cookies", href: "/cookies"

      click_button "Reject analytics cookies"
      expect(page).to have_no_text banner_title
      expect(page).to have_css "[role=alert]", text: banner_reject

      click_button "Hide cookie message"
      expect(page).to have_no_text banner_reject

      click_link "Start now"
      expect(page).to have_css "h1", text: "What type of property is the certificate for?"
      expect(page).to have_no_text banner_title
      expect(page).to have_no_css %(script[src^="#{analytics_script_host}"]), visible: :all

      click_link "Cookies"
      within_fieldset "Cookies on our service" do
        expect(page).to have_checked_field "Do not use cookies that measure my website use", visible: :all
      end
    end

    it "shows the cookie banner, you can ignore it and the banner continues to show" do
      visit url
      expect(page).to have_text banner_title

      click_link "Start now"
      expect(page).to have_css "h1", text: "What type of property is the certificate for?"
      expect(page).to have_text banner_title
      expect(page).to have_css %(script[src^="#{analytics_script_host}"]), visible: :all

      click_link "Cookies"
      within_fieldset "Cookies on our service" do
        expect(page).to have_checked_field "Use cookies that measure my website use", visible: :all
      end
    end

    it "does not show the cookie banner on the cookies page" do
      visit url
      expect(page).to have_text banner_title

      click_link "View cookies"
      expect(page).to have_css "h1", text: "Cookies on our service"
      expect(page).to have_no_text banner_title
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

      click_button "Reject analytics cookies"
      expect(page).to have_no_text banner_title

      ga_cookies = page.driver.browser.manage.all_cookies.filter { it[:name].start_with?("_ga") }
      expect(ga_cookies.length).to be_zero
    end
  end

  it_behaves_like "there is a cookie banner" do
    let(:url) { "http://find-energy-certificate.local.gov.uk:9393/" }
    let(:banner_title) { "Cookies on Find an energy certificate" }
  end

  it_behaves_like "there is a cookie banner" do
    let(:url) { "http://getting-new-energy-certificate.local.gov.uk:9393" }
    let(:banner_title) { "Cookies on Get a new energy certificate" }
  end
end
