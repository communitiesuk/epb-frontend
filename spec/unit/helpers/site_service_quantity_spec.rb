# frozen_string_literal: true

describe "Helpers.site_service_quantity", type: :helper do
  context "with site services" do
    let(:frontend_service_helpers) do
      Class.new { extend Helpers }
    end

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
      expect(
        frontend_service_helpers.site_service_quantity(
          assessment,
          "Electricity",
        ),
      ).to eq "751445"
    end

    it "does show the value for gas" do
      expect(
        frontend_service_helpers.site_service_quantity(assessment, "Gas"),
      ).to eq "72956"
    end

    it "does not show the value for nonexistent service" do
      expect(
        frontend_service_helpers.site_service_quantity(assessment, "Oil"),
      ).to be_nil
    end
  end
end
