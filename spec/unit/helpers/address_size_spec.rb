# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context "when checking address size" do
    let(:long_address) do
      {
        addressId: "UPRN-000000000001",
        addressLine1: "2 Lonely Street",
        addressLine2: "hnnnnnnnnnnnnnnnnnnnn",
        addressLine3: "jssssssssssssssssssss",
        addressLine4: "pwwwwwwwwwwwwwwwwww",
        town: "Post-Town1",
        postcode: "A0 0AA",
      }
    end

    let(:short_address) do
      {
        addressId: "UPRN-000000000001",
        addressLine1: "2 Lonely Street",
        addressLine2: nil,
        addressLine3: nil,
        addressLine4: nil,
        town: "Post-Town1",
        postcode: "A0 0AA",
      }
    end

    let(:long_line_address) do
      {
        addressId: "UPRN-000000000001",
        addressLine1: "2 Lonely Street next to the pond near the old lane",
        addressLine2: "Something row",
        addressLine3: "Whats it place",
        addressLine4: nil,
        town: "Post-Town1",
        postcode: "A0 0AA",
      }
    end

    it "show the number of lines" do
      expect(
        HelpersStub.new.address_size(long_address),
      ).to eq "govuk-body small-font"
    end

    it "show the number of lines" do
      expect(HelpersStub.new.address_size(short_address)).to eq "govuk-body"
    end

    it "show the number of lines" do
      expect(
        HelpersStub.new.address_size(long_line_address),
      ).to eq "govuk-body small-font"
    end
  end
end
