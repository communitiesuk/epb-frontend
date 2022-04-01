describe "Helpers.resolve_bad_encoding_chars", type: :helper do
  subject(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "when money amount contains ? character rather than £" do
    it "converts the ? to a £" do
      expect(frontend_service_helpers.resolve_bad_encoding_chars("?3,000.00")).to eq "£3,000.00"
    end
  end

  context "when money amount contains Â£ as a bad encoding artefact" do
    it "removes the Â to leave £" do
      expect(frontend_service_helpers.resolve_bad_encoding_chars("Â£800 - Â£1,200")).to eq "£800 - £1,200"
    end
  end

  context "when money amount contains no bad encoding characters" do
    it "leaves the money amount string unaffected" do
      amount = "£12,000"
      expect(frontend_service_helpers.resolve_bad_encoding_chars(amount)).to eq amount
    end
  end
end
