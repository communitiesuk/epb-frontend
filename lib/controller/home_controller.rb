# frozen_string_literal: true

module Controller
  class HomeController < BaseController
    get "/healthcheck" do
      status 200
    end

    get "/accessibility-statement" do
      status 200
      @page_title =
        "#{t('accessibility_statement.top_heading')} – #{t('layout.body.govuk')}"
      erb :accessibility_statement
    end
  end
end
