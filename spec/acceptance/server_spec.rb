# frozen_string_literal: true

describe "Acceptance::Server", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get /index for getting-new-energy-certificate" do
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

  describe ".get /index for find-energy-certificate" do
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

  describe ".get /healthcheck" do
    let(:response) { get "/healthcheck" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end
  end

  describe ".get a non-existent page" do
    let(:response) { get "/this-page-does-not-exist" }

    it "returns status 404" do
      expect(response.status).to eq(404)
    end
  end
end
