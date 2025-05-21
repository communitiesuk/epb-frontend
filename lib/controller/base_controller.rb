require "erubis"
require "i18n"
require "i18n/backend/fallbacks"
require "sinatra/base"
require "sinatra/cookies"
require_relative "../container"
require_relative "../helper/toggles"

module Controller
  class BaseController < Sinatra::Base
    helpers Helpers
    attr_reader :toggles
    set :views, "lib/views"
    set :erb, escape_html: true
    set :public_folder, proc { File.join(root, "/../../public") }
    set :static_cache_control, [:public, { max_age: 60 * 60 * 24 * 7 }] if ENV["ASSETS_VERSION"]

    if ENV["STAGE"] == "test"
      require "capybara-lockstep"
      include Capybara::Lockstep::Helper
      set :show_exceptions, :after_handler
    end

    def initialize(*args)
      super
      setup_locales
      @toggles = Helper::Toggles
      @container = Container.new
      @logger = Logger.new($stdout)
      @logger.level = Logger::INFO
    end

    Helper::Assets.setup_cache_control(self)

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
      also_reload "lib/**/*.rb"
      set :host_authorization, { permitted_hosts: [] }
    end

    before do
      set_locale
      raise MaintenanceMode if request.path != "/healthcheck" && Helper::Toggles.enabled?("frontend-maintenance-mode")

      if redirect_to_service_start_page?
        cache_control :no_cache, :no_store
        redirect(static_start_page, 303)
      end
    end

    FIND_ENERGY_CERTIFICATE_HOST_NAME = "find-energy-certificate".freeze
    GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME = "getting-new-energy-certificate".freeze

    EXCLUDE_GREEN_DEAL_REFERRER_PATHS = %w[
      /find-a-certificate/search-by-postcode
      /find-a-certificate/search-by-street-name-and-town
    ].freeze

    def show(template, locals, layout = :layout)
      locals[:errors] = @errors
      erb template, layout:, locals:
    end

    def show_with_print_option(
      template,
      locals,
      is_print_view,
      skip_custom_css: false
    )
      @skip_custom_css = true if skip_custom_css
      show(
        template,
        locals.merge({ print_view: is_print_view }),
        is_print_view ? :print_layout : :layout,
      )
    end

    not_found do
      @page_title = "#{t('error.404.heading')} – #{t('layout.body.govuk')}"
      status 404
      erb :error_page_404 unless @errors
    end

    class MaintenanceMode < RuntimeError
      include Errors::DoNotReport
    end

    error MaintenanceMode do
      status 503
      @page_title =
        "#{t('service_unavailable.title')} – #{t('layout.body.govuk')}"
      erb :service_unavailable
    end

    def server_error(exception)
      was_timeout = exception.is_a?(Errors::RequestTimeoutError)
      Sentry.capture_exception(exception) if defined?(Sentry) && !was_timeout

      message =
        exception.methods.include?(:message) ? exception.message : exception

      error = { type: exception.class.name, message: }

      if exception.methods.include? :backtrace
        error[:backtrace] = exception.backtrace
      end

      @logger.error JSON.generate(error)
      @page_title =
        "#{t('error.500.heading')} – #{t('layout.body.govuk')}"
      status(was_timeout ? 504 : 500)
      erb :error_page_500
    end
  end
end
