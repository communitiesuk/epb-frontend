# frozen_string_literal: true

require "net/http"

describe "Integration::Rackup" do
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

    process.readline # wait for initial output from server; ensures it's started
  end

  after(:all) { Process.kill("KILL", process_id) if process_id }

  let(:request_assessor) do
    Net::HTTP.new("getting-new-energy-certificate.local.gov.uk", 9_393)
  end
  let(:request_certificate) do
    Net::HTTP.new("find-energy-certificate.local.gov.uk", 9_393)
  end

  describe "GET /getting-new-energy-certificate" do
    it "renders the getting-new-energy-certificate page" do
      req = Net::HTTP::Get.new("/")
      response = request_assessor.request(req)
      expect(response.code).to eq("200")
      expect(response.body).to include("Get a new energy certificate")
    end
  end

  describe "GET /find-energy-certificate.local.gov.uk" do
    it "renders the find-energy-certificate.local.gov.uk page" do
      req = Net::HTTP::Get.new("/")
      response = request_certificate.request(req)
      expect(response.code).to eq("200")
      expect(response.body).to include("Find an energy certificate")
    end
  end

  describe "GET /healthcheck" do
    it "passes a healthcheck" do
      req = Net::HTTP::Get.new("/healthcheck")
      response = request_assessor.request(req)
      expect(response.code).to eq("200")
    end
  end

  describe "GET non-existent page" do
    it "returns custom 404 error page" do
      req = Net::HTTP::Get.new("/this-page-does-not-exist")
      response = request_assessor.request(req)
      expect(response.code).to eq("404")
      expect(response.body).to include(
        "If you typed the web address, check it is correct.",
      )
    end
  end
end
