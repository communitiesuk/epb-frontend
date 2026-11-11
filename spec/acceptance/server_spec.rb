# frozen_string_literal: true

describe "Acceptance::Server", type: :feature do
  include RSpecFrontendServiceMixin

  describe "GET /index for getting-new-energy-certificate" do
    let(:response) { get "http://getting-new-energy-certificate.local.gov.uk/" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "includes the index page title" do
      expect(response.body).to have_css "h1", text: "Get a new energy certificate"
    end

    context "when lang=cy" do
      let(:response) { get "http://getting-new-energy-certificate.local.gov.uk/?lang=cy" }

      it "includes the welsh index page title" do
        expect(response.body).to have_css "h1", text: "Cael tystysgrif ynni newydd"
      end
    end

    context "when lang=en" do
      let(:response) { get "http://getting-new-energy-certificate.local.gov.uk/?lang=en" }

      it "includes the english index page title" do
        expect(response.body).to have_css "h1", text: "Get a new energy certificate"
      end
    end

    context "when a static start page is set" do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("STATIC_START_PAGE_GETTING_EN").and_return("http://example.com")
      end

      it "redirects to the static start page" do
        expect(response.status).to eq 301
        expect(response.location).to eq "http://example.com"
      end
    end

    context "when a static start page is set and lang=cy" do
      let(:response) { get "http://getting-new-energy-certificate.local.gov.uk/?lang=cy" }

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("STATIC_START_PAGE_GETTING_CY").and_return("http://example.com")
      end

      it "redirects to the static start page" do
        expect(response.status).to eq 301
        expect(response.location).to eq "http://example.com"
      end
    end
  end

  describe "GET /index for find-energy-certificate" do
    let(:response) { get "http://find-energy-certificate.local.gov.uk/" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "includes the index page title" do
      expect(response.body).to have_css "h1", text: "Find an energy certificate"
    end

    context "when lang=cy" do
      let(:response) { get "http://find-energy-certificate.local.gov.uk/?lang=cy" }

      it "includes the welsh index page title" do
        expect(response.body).to have_css "h1", text: "Dod o hyd i dystysgrif ynni"
      end
    end

    context "when lang=en" do
      let(:response) { get "http://find-energy-certificate.local.gov.uk/?lang=en" }

      it "includes the english index page title" do
        expect(response.body).to have_css "h1", text: "Find an energy certificate"
      end
    end

    context "when a static start page is set" do
      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("STATIC_START_PAGE_FINDING_EN").and_return("http://example.com")
      end

      it "redirects to the static start page" do
        expect(response.status).to eq 301
        expect(response.location).to eq "http://example.com"
      end
    end

    context "when a static start page is set and lang=cy" do
      let(:response) { get "http://find-energy-certificate.local.gov.uk/?lang=cy" }

      before do
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with("STATIC_START_PAGE_FINDING_CY").and_return("http://example.com")
      end

      it "redirects to the static start page" do
        expect(response.status).to eq 301
        expect(response.location).to eq "http://example.com"
      end
    end
  end

  describe "GET /healthcheck" do
    let(:response) { get "/healthcheck" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe "GET a non-existent page" do
    let(:response) { get "/this-page-does-not-exist" }

    it "returns status 404" do
      expect(response.status).to eq(404)
      expect(response.body).to have_title "Page not found – GOV.UK"
    end
  end

  describe "GET a non-existent page in welsh" do
    let(:response) { get "/this-page-does-not-exist?lang=cy" }

    it "returns status 404" do
      expect(response.status).to eq(404)
      expect(response.body).to have_title "Y tudalen heb ei ganfod – GOV.UK"
    end
  end

  context "when an uncaught error is raised" do
    let(:logger) { instance_double(Logger) }
    let(:show_exceptions) { false }
    let(:exception) { "boom" }

    let(:app) do
      test_logger = logger
      test_show_exceptions = show_exceptions
      test_exception = exception
      Class.new(FrontendService) do
        set :logger, test_logger
        set :show_exceptions, test_show_exceptions
        set :raise_errors, false

        get "/test-error" do
          raise test_exception
        end
      end
    end

    before do
      allow(Sentry).to receive(:capture_exception)
      allow(logger).to receive(:error)
      get "/test-error"
    end

    context "when in a production environment" do
      let(:show_exceptions) { false }

      it "responds with a 500 status" do
        expect(last_response.status).to eq 500
      end

      it "does not display a verbose error message" do
        expect(last_response.body).to have_no_text "boom"
        expect(last_response.body).to have_no_text "Sorry, there is a problem with the service."
      end

      it "logs the error to the log file" do
        expect(logger).to have_received(:error).with(include('"type":"RuntimeError","message":"boom","backtrace":['))
      end

      it "logs the error to sentry" do
        expect(Sentry).to have_received(:capture_exception).with(
          have_attributes(
            class: RuntimeError,
            message: "boom",
          ),
        )
      end
    end

    context "when a timeout error is raised in a production environment" do
      let(:show_exceptions) { false }
      let(:exception) { Errors::RequestTimeoutError }

      it "responds with a 504 status" do
        expect(last_response.status).to eq 504
      end

      it "does not display a verbose error message" do
        expect(last_response.body).to have_no_text "boom"
        expect(last_response.body).to have_no_text "Sorry, there is a problem with the service."
      end

      it "logs the error to the log file" do
        expect(logger).to have_received(:error).with(include('"type":"Errors::RequestTimeoutError","message":"Errors::RequestTimeoutError","backtrace":['))
      end

      it "does not log the error to sentry" do
        expect(Sentry).not_to have_received(:capture_exception)
      end
    end

    context "when in a development environment" do
      let(:show_exceptions) { :after_handler }

      it "responds with a 500 status" do
        expect(last_response.status).to eq 500
      end

      it "displays the message" do
        expect(last_response.body).to have_text "boom"
      end

      it "does not log the error to the log file" do
        expect(logger).not_to have_received(:error).with(include("boom"))
      end

      it "does not log the error to sentry" do
        expect(Sentry).not_to have_received(:capture_exception)
      end
    end
  end
end
