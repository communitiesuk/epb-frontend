# frozen_string_literal: true

describe "Helpers.cleansed_domestic_qualification_type_param", type: :helper do
  context "when cleansing domestic qualification type params" do
    it "returns a single valid qualification string" do
      expect(
        Helpers.cleansed_domestic_qualification_type_param(
          "domesticSap",
        ),
      ).to eq "domesticSap"
    end

    it "returns multiple valid qualification strings" do
      expect(
        Helpers.cleansed_domestic_qualification_type_param(
          "domesticSap,domesticRdSap",
        ),
      ).to eq "domesticSap,domesticRdSap"
    end

    it "excludes invalid domestic qualification strings" do
      expect(
        Helpers.cleansed_domestic_qualification_type_param(
          "domesticSap,domesticNOS3,domesticRdSap",
        ),
      ).to eq "domesticSap,domesticRdSap"
    end

    it "returns nil if there are no valid domestic qualification values" do
      expect(
        Helpers.cleansed_domestic_qualification_type_param(
          "rubbish,junk,someOtherStuff,domesticRdSapP",
        ),
      ).to be_nil
    end
  end
end
