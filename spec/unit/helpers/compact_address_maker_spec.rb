describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  context "when compacting address" do
    let(:address_lines_with_occupier) do
      ["Shop owners are us", "2 Lonely Street", "Something road"]
    end

    let(:address_lines_without_occupier) do
      ["2 Lonely Street", "Something road"]
    end

    let(:town) { "Knowhere" }
    let(:postcode) { "A0 0AA" }
    let(:occupier) { "Shop owners are us" }

    it "shows the address when the occupier is duplicated in the address" do
      response =
        HelpersStub.new.compact_address_without_occupier(
          address_lines_with_occupier,
          town,
          postcode,
          occupier,
        )
      expect(response).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end

    it "shows  the address when the occupier is not duplicated in the address" do
      response =
        HelpersStub.new.compact_address_without_occupier(
          address_lines_without_occupier,
          town,
          postcode,
          occupier,
        )
      expect(response).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end

    it "shows the address when the occupier is empty" do
      occupier = ""
      response =
        HelpersStub.new.compact_address_without_occupier(
          address_lines_without_occupier,
          town,
          postcode,
          occupier,
        )
      expect(response).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end

    it "shows the address when the occupier is whitespace" do
      occupier = " "
      response =
        HelpersStub.new.compact_address_without_occupier(
          address_lines_without_occupier,
          town,
          postcode,
          occupier,
        )
      expect(response).to eq(
        ["2 Lonely Street", "Something road", "Knowhere", "A0 0AA"],
      )
    end
  end
end
