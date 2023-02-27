# frozen_string_literal: true

describe "Acceptance::Locales" do
  include RSpecFrontendServiceMixin

  describe ".get / with different language parameters" do
    let(:response_welsh) { get "/?lang=cy" }
    let(:response_english) { get "/?lang=en" }

    it "shows Welsh: when lang=cy" do
      expect(response_welsh.body).to include("Y tudalen heb ei ganfod")
    end

    it "does not show Welsh: when lang=en" do
      expect(response_english.body).not_to include("Sgipiwch i’r prif gynnwys")
    end
  end
end
