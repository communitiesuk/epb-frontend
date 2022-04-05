# frozen_string_literal: true

describe "Acceptance::Server" do
  include RSpecFrontendServiceMixin

  describe ".get /index for getting-new-energy-certificate", type: :feature do
    let(:response) { get "http://getting-new-energy-certificate.local.gov.uk/" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "includes the index page title" do
      expect(response.body).to have_css "h1",
                                        text: "Get a new energy certificate"
    end
  end

  describe ".get /index for find-energy-certificate", type: :feature do
    let(:response) { get "http://find-energy-certificate.local.gov.uk/" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "includes the index page title" do
      expect(response.body).to have_css "h1", text: "Find an energy certificate"
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
