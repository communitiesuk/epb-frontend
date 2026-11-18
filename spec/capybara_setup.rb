# frozen_string_literal: true

Capybara.register_driver :custom_chrome_headless do |app|
  Capybara::Selenium::Driver.load_selenium
  options = Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument("--headless=new")
    opts.add_argument("--disable-gpu") if Gem.win_platform?
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument("--disable-site-isolation-trials")
    opts.add_argument("--disable-background-timer-throttling")
    opts.add_argument("--disable-backgrounding-occluded-windows")
    opts.add_argument("--disable-infobars")
    opts.add_argument("--disable-renderer-backgrounding")
    opts.add_argument("--no-sandbox")
    opts.add_argument("--window-size=1280,1024")
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.default_driver = :custom_chrome_headless
Capybara.javascript_driver = :custom_chrome_headless
Capybara.app_host = "http://localhost:9393"

# TODO: remove when next version of Capybara is released (> 3.40.0)
# Chrome 134 can thrown
# Selenium::WebDriver::Error::UnknownError:
# unknown error: unhandled inspector error: {"code":-32000,"message":"Node with given id does not belong to the document"}
#
# Capybara's retry mechanism should catch and retry on this error but it does not.
#
# This patch ensures Capybara's internal synchronize retry will retry on these errors
#
# See https://github.com/teamcapybara/capybara/issues/2800
# And https://github.com/teamcapybara/capybara/blob/53e7254c528d13a8ff5f4438085eb9dda0a287b0/lib/capybara/node/base.rb#L134
class Capybara::Node::Base
  prepend(Module.new do
    protected def catch_error?(error, errors = nil)
      super || (error.is_a?(Selenium::WebDriver::Error::UnknownError) && error.message.include?("Node with given id does not belong to the document"))
    end
  end)
end

# TODO: check if this has been fixed when the next version of Capybara is released (> 3.40.0)
# Chrome 158 does not allow resetting storage using * as a domain
# This is a copy of the existing reset modified so it doesn't error
# This will only reset local storage on our app_host
#
# See https://github.com/teamcapybara/capybara/issues/2865
module Capybara::Selenium::Driver::ChromeDriver
  def reset!
    return unless @browser

    switch_to_window(window_handles.first)
    window_handles.slice(1..).each { |win| close_window(win) }
    return super if chromedriver_version < 73

    timer = Capybara::Helpers.timer(expire_in: 10)
    begin
      clear_storage unless uniform_storage_clear?
      @browser.navigate.to("about:blank")
      wait_for_empty_page(timer)
    rescue *unhandled_alert_errors
      accept_unhandled_reset_alert
      retry
    end

    execute_cdp("Storage.clearCookies")
    if clear_all_storage?
      execute_cdp(
        "Storage.clearDataForOrigin",
        origin: URI(Capybara.app_host).origin,
        storageTypes: "local_storage",
      )
    end
  end
end
