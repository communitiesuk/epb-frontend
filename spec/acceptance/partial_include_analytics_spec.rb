require "sinatra/cookies"

describe "Partial include analytics", type: :feature do
  include RSpecFrontendServiceMixin

  let(:url) do
    "http://find-energy-certificate.local.gov.uk/find-a-certificate/type-of-property"
  end

  before do
    allow(CGI).to receive(:h).and_return("123456")
  end

  after do
    ENV["GTM_PROPERTY_FINDING"] = nil
  end

  context "when the cookie_consent cookie is null" do
    before do
      ENV["GTM_PROPERTY_FINDING"] = "GT6666"
    end

    let(:response) do
      get url
    end

    it "includes the partial in the layout" do
      expect(response.body).to include("https://www.googletagmanager.com/gtm.js?id=")
    end

    it "includes the partial no script in the layout" do
      expect(response.body).to include("https://www.googletagmanager.com/ns.html?id")
    end
  end

  context "when the cookie_consent cookie is true" do
    before do
      ENV["GTM_PROPERTY_FINDING"] = "GT6666"
    end

    let(:response) do
      get url, {}, "HTTP_COOKIE" => "cookie_consent=true"
    end

    it "includes the partial in the layout" do
      expect(response.body).to include("https://www.googletagmanager.com/gtm.js?id=")
    end

    it "includes the partial no script in the layout" do
      expect(response.body).to include("https://www.googletagmanager.com/ns.html?id")
    end

    it "include the gtag script" do
      expect(response.body).to include("gtag()")
    end
  end

  context "when the cookie_consent cookie is false" do
    let(:helper) { instance_double(Helpers) }
    let(:response) do
      get url, {}, "HTTP_COOKIE" => "cookie_consent=false"
    end

    before do
      ENV["GTM_PROPERTY_FINDING"] = "GT6666"
    end

    it "does not include the partial in the layout" do
      expect(response.body).not_to include("https://www.googletagmanager.com/gtm.js?id=")
    end

    it "does not include the partial no script in the layout" do
      expect(response.body).not_to include("https://www.googletagmanager.com/ns.html?id")
    end

    it "include the gtag script" do
      expect(response.body).not_to include("gtag()")
    end
  end

  context "when the google_property is false" do
    before do
      ENV["GTM_PROPERTY_FINDING"] = nil
    end

    let(:response) do
      get url, {}, "HTTP_COOKIE" => "cookie_consent=true"
    end

    it "does not include the partial in the layout" do
      expect(response.body).not_to include("https://www.googletagmanager.com/gtm.js?id=")
    end

    it "does not include the partial no script in the layout" do
      expect(response.body).not_to include("https://www.googletagmanager.com/ns.html?id")
    end
  end
end
