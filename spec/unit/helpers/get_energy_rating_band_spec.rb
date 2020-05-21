# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context "given a recommended improvment number" do
    it "number 1" do
      expect(HelpersStub.new.get_energy_rating_band(100)).to eq("a")
    end

    it "number 2" do
      expect(HelpersStub.new.get_energy_rating_band(72)).to eq("c")
    end

    it "number 3 to 9" do
      expect(HelpersStub.new.get_energy_rating_band(300)).to eq(nil)
    end
  end
end
