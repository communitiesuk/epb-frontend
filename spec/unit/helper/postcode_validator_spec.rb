describe Helper::PostcodeValidator do
  let(:helper) { described_class }

  context "when postcode is valid" do
    it "does not raise an error", aggregate_failures: true do
      expect { helper.validate("SW1V 0AA") }.not_to raise_error
      expect { helper.validate("sw1 0bb") }.not_to raise_error
      expect { helper.validate("SW1 0AA") }.not_to raise_error
      expect { helper.validate("N1 0AA") }.not_to raise_error
      expect { helper.validate(" LS1 4AP ") }.not_to raise_error
      expect(helper.validate("LS1 4AP")).to be true
      expect(helper.validate("LS14AP")).to be true
      expect(helper.validate("ls14ap")).to be true
      expect(helper.validate("AA99 9AA")).to be true
    end
  end

  context "when postcode is not complete" do
    it "raise an incomplete error", aggregate_failures: true do
      expect { helper.validate("") }.to raise_error Errors::PostcodeIncomplete
      expect { helper.validate("SW") }.to raise_error Errors::PostcodeIncomplete
      expect { helper.validate("SW1 ") }.to raise_error Errors::PostcodeIncomplete
      expect { helper.validate("SW1") }.to raise_error Errors::PostcodeIncomplete
      expect { helper.validate("OX29") }.to raise_error Errors::PostcodeIncomplete
    end
  end

  context "when postcode is not valid" do
    it "raise an invalid error", aggregate_failures: true do
      expect { helper.validate("$$") }.to raise_error Errors::PostcodeNotValid
      expect { helper.validate("SW%1 0AA") }.to raise_error Errors::PostcodeNotValid
      expect { helper.validate("sw$1 0aa") }.to raise_error Errors::PostcodeNotValid
      expect { helper.validate("SW1V ^AA") }.to raise_error Errors::PostcodeNotValid
      expect { helper.validate("$$$ 0AA") }.to raise_error Errors::PostcodeNotValid
    end
  end

  context "when a valid postcode is too long" do
    it "raise an invalid error", aggregate_failures: true do
      expect { helper.validate("SW1V 0AA9") }.to raise_error Errors::PostcodeWrongFormat
      expect { helper.validate("SW1VA 0AA") }.to raise_error Errors::PostcodeWrongFormat
    end
  end
end
