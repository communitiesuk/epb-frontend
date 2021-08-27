# frozen_string_literal: true

describe "Helpers.number_to_currency", type: :helper do
  subject(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "when a valid number is given" do
    it "returns single digit formatted currency" do
      expect(frontend_service_helpers.number_to_currency(0.50)).to eq("£0.50")
    end

    it "returns four digit formatted currency" do
      expect(frontend_service_helpers.number_to_currency(7334.00)).to eq(
        "£7,334",
      )
    end

    it "returns five digit formatted currency" do
      expect(frontend_service_helpers.number_to_currency(25_000.90)).to eq(
        "£25,000.90",
      )
    end

    it "returns seven digit formatted currency" do
      expect(frontend_service_helpers.number_to_currency(1_250_600.99)).to eq(
        "£1,250,600.99",
      )
    end

    context "when a valid number is given in string format" do
      it "returns formatted currency" do
        expect(frontend_service_helpers.number_to_currency("123.90")).to eq(
          "£123.90",
        )
      end
    end
  end
end
