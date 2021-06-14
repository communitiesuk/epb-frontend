# frozen_string_literal: true

describe UseCase::FindAssessorByName do
  context "when there are no assessors for that name" do
    let(:assessors_gateway) { AssessorsGateway::EmptyStub.new }
    let(:find_assessor) { described_class.new(assessors_gateway) }

    it "returns empty array" do
      expect(find_assessor.execute("Uncommon Name")[:data][:assessors]).to eq(
        [],
      )
    end
  end

  context "when there are assessors matched by the name" do
    let(:valid_assessors) do
      [
        {
          "firstName": "Somewhatcommon",
          "lastName": "Name",
          "contactDetails": {
            "telephoneNumber": "0792 102 1368",
            "email": "epbassessor@epb.com",
          },
          "searchResultsComparisonPostcode": "SW1A 1AA",
          "registeredBy": {
            "schemeId": "432",
            "name": "EPBs 4 U",
          },
          "distanceFromPostcodeInMiles": 0.1,
        },
        {
          "firstName": "Somewhatcommon",
          "lastName": "Name",
          "contactDetails": {
            "telephoneNumber": "0792 102 1368",
            "email": "epbassessor@epb.com",
          },
          "searchResultsComparisonPostcode": "SW1A 1AA",
          "registeredBy": {
            "schemeId": "432",
            "name": "EPBs 4 U",
          },
          "distanceFromPostcodeInMiles": 0.3,
        },
      ]
    end

    let(:assessors_gateway) { AssessorsGateway::Stub.new }
    let(:find_assessor) { described_class.new(assessors_gateway) }

    it "returns list of assessors" do
      expect(
        find_assessor.execute("Somewhatcommon Name")[:data][:assessors],
      ).to eq(valid_assessors)
    end

    it "returns list of assessors when the name includes leading or trailing whitespaces" do
      expect(
        find_assessor.execute(" Somewhatcommon   Name ")[:data][:assessors],
      ).to eq(valid_assessors)
    end
  end
end
