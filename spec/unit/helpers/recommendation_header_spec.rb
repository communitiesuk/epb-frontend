class HelpersStub
  include Helpers
end

describe "Helpers.recommendation_header", type: :helper do
  before do
    I18n.locale = I18n.default_locale
  end

  context "when a recommendation has no improvement code" do
    title = "This is the title for the improvement"
    description = "and this is the description"

    let(:recommendation) do
      { improvementTitle: title, improvementDescription: description }
    end

    it "makes title and description available" do
      header = HelpersStub.new.recommendation_header(recommendation)
      expect(header.title).to eq title
      expect(header.description).to eq description
    end
  end

  context "when a recommendation has an improvement code" do
    let(:recommendation) { { improvementCode: 3 } }

    it "makes title and description available" do
      header = HelpersStub.new.recommendation_header(recommendation)
      expect(header.title).to eq "Hot water cylinder insulation"
      expect(
        header.description,
      ).to eq "Add additional 80 mm jacket to hot water cylinder"
    end
  end
end
