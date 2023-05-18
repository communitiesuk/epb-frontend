# frozen_string_literal: true

describe "Helpers.number_to_delimited", type: :helper do
  subject(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "when a valid number is given" do
    it "returns with a single delimiter" do
      expect(frontend_service_helpers.number_to_delimited(1234)).to eq("1,234")
    end

    it "returns with a single delimiter and the separator" do
      expect(frontend_service_helpers.number_to_delimited(1234.5)).to eq(
        "1,234.5",
      )
    end

    it "returns 3 digits with no delimiters" do
      expect(frontend_service_helpers.number_to_delimited(123)).to eq(
        "123",
      )
    end

    context "when a valid number is given in string format" do
      it "returns with delimiters" do
        expect(frontend_service_helpers.number_to_delimited("1234")).to eq(
          "1,234",
        )
      end
    end

    context "when a valid number is given in string format having been shortened" do
      it "returns with delimiters" do
        expect(frontend_service_helpers.number_to_delimited(sprintf("%g", 1234.0))).to eq(
          "1,234",
        )
      end
    end
  end
end
