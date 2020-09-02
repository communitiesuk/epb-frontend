# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context "given an energy efficiency rating value" do
    it "converts 100 to an A band" do
      expect(HelpersStub.new.get_energy_rating_band(100)).to eq "a"
    end

    it "converts 0 to nil" do
      expect(HelpersStub.new.get_energy_rating_band(0)).to eq "g"
    end

    it "converts 1 to an g band" do
      expect(HelpersStub.new.get_energy_rating_band(1)).to eq "g"
    end

    it "converts 20 to an g band" do
      expect(HelpersStub.new.get_energy_rating_band(20)).to eq "g"
    end

    it "converts 21 to an f band" do
      expect(HelpersStub.new.get_energy_rating_band(21)).to eq "f"
    end

    it "converts 72 to a C band" do
      expect(HelpersStub.new.get_energy_rating_band(72)).to eq "c"
    end

    it "converts 300 to nil" do
      expect(HelpersStub.new.get_energy_rating_band(300)).to eq "a"
    end
  end
end
