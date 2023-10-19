# frozen_string_literal: true

describe "Helpers.potential_rating_text", type: :helper do
  let(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  before do
    I18n.locale = I18n.default_locale
  end

  context "when provided with the recommendation numerical index" do
    it "number 1" do
      expect(frontend_service_helpers.potential_rating_text(1)).to eq(
        "Potential rating after completing step 1",
      )
    end

    it "number 2" do
      expect(frontend_service_helpers.potential_rating_text(2)).to eq(
        "Potential rating after completing steps 1&nbsp;and&nbsp;2",
      )
    end

    it "number 3 to 9" do
      expect(frontend_service_helpers.potential_rating_text(3)).to eq(
        "Potential rating after completing steps 1&nbsp;to&nbsp;3",
      )
    end
  end
end
