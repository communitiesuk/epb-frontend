# frozen_string_literal: true

shared_context "when awaiting responses" do
  def retry_operation(max_attempts: 50)
    attempts = 0
    begin
      attempts += 1
      yield
    rescue StandardError => e
      if attempts < max_attempts
        sleep(1) # Optional: Add delay between retries
        retry
      else
        raise "Operation failed after #{max_attempts} attempts. Last error: #{e.message}"
      end
    end
  end
end

describe "Journey::CookiesOnOurService", :journey, type: :feature do
  let(:url) do
    "http://find-energy-certificate.local.gov.uk:9393/cookies"
  end

  include_context "when awaiting responses"
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

  context "when selecting to not use cookies" do
    before do
      visit url
      find("#cookies-setting-false-label").click
      find("button").click
    end

    let(:session) do
      Capybara.current_session.driver.browser.manage
    end

    let(:cookie) do
      retry_operation do
        session.cookie_named("cookie_consent")
      end
    end

    it "shows the success page" do
      expect(page).to have_css("h2", text: "Success")
      expect(page).to have_css("h3", text: "You’ve set your cookie preferences")
    end

    it "has set the cookie_consent to be false" do
      expect(cookie[:value]).to eq "false"
    end
  end

  context "when selecting to use cookies" do
    before do
      visit url
      find("#cookies-setting-true-label").click
      find("button").click
    end

    let(:cookie) do
      retry_operation do
        browser = Capybara.current_session.driver.browser.manage
        browser.cookie_named("cookie_consent")
      end
    end

    it "shows the success page" do
      expect(page).to have_css("h2", text: "Success")
      expect(page).to have_css("h3", text: "You’ve set your cookie preferences")
    end

    it "has set the cookie_consent to be true" do
      expect(cookie[:value]).to eq "true"
    end
  end
end
