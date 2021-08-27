describe "Helpers.compact_address_without_occupier", type: :helper do
  subject(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "when compacting address" do
    let(:address_lines) do
      OpenStruct.new(
        with_occupier: ["Shop owners are us", "2 Lonely Street", "Something road"],
        without_occupier: ["2 Lonely Street", "Something road"],
      )
    end

    let(:town) { "Knowhere" }
    let(:postcode) { "A0 0AA" }
    let(:occupier) { "Shop owners are us" }

    context "when the occupier is duplicated in the address" do
      let(:result) do
        frontend_service_helpers.compact_address_without_occupier(
          address_lines.with_occupier,
          town,
          postcode,
          occupier,
        )
      end

      it "shows the address when the occupier is duplicated in the address" do
        expect(result).to eq(
          ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
        )
      end
    end

    it "shows the address when the occupier is not duplicated in the address" do
      result =
        frontend_service_helpers.compact_address_without_occupier(
          address_lines.without_occupier,
          town,
          postcode,
          occupier,
        )
      expect(result).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end

    it "shows the address when the occupier is empty" do
      occupier = ""
      result =
        frontend_service_helpers.compact_address_without_occupier(
          address_lines.without_occupier,
          town,
          postcode,
          occupier,
        )
      expect(result).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end

    it "shows the address when the occupier is whitespace" do
      occupier = " "
      result =
        frontend_service_helpers.compact_address_without_occupier(
          address_lines.without_occupier,
          town,
          postcode,
          occupier,
        )
      expect(result).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end
  end
end
