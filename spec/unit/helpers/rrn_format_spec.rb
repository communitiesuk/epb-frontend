describe "Helpers.rrn_format", type: :helper do
  context "when validating that a string could be a valid RRN" do
    it "returns true for the standard RRN format with dashes" do
      expect(
        Helpers.rrn_format?("1234-5678-1234-5678-1234"),
      ).to be(true)
    end

    it "returns true for 20 digits without dashes" do
      expect(
        Helpers.rrn_format?("12345678123456781234"),
      ).to be(true)
    end

    it "returns false for too many digits" do
      expect(
        Helpers.rrn_format?("1234-5678-1234-5678-1234-1"),
      ).to be(false)
    end

    it "returns false for too few digits" do
      expect(
        Helpers.rrn_format?("1234-5678-1234-567"),
      ).to be(false)
    end

    it "returns true with incorrectly placed hyphens" do
      expect(
        Helpers.rrn_format?("1234-5678-1234-56781234"),
      ).to be(true)
    end

    it "returns false when there are letters" do
      expect(
        Helpers.rrn_format?("1234-5678-ABCD-5678-DEFG"),
      ).to be(false)
    end
  end
end
