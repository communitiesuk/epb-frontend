# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context "with site services" do
    let(:assessment) do
      {
        siteServiceOne: {
          description: "Electricity",
          quantity: "751445",
        },
        siteServiceTwo: {
          description: "LOTS OF Gas",
          quantity: "72956",
        },
        siteServiceThree: {
          description: "Not used",
          quantity: "0",
        },
      }
    end
    it "does show the value for electricity" do
      expect(HelpersStub.new.site_service_quantity(assessment, "Electricity")).to eq "751445"
    end

    it "does show the value for gas" do
      expect(HelpersStub.new.site_service_quantity(assessment, "Gas")).to eq "72956"
    end

    it "does not show the value for nonexistent service" do
      expect(HelpersStub.new.site_service_quantity(assessment, "Oil")).to eq nil
    end
  end
end
