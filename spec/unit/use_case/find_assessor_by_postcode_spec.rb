# frozen_string_literal: true

describe UseCase::FindAssessorByPostcode do
  it "raises an error when the postcode doesn't exist" do
    find_assessors_without_existing_postcode =
      described_class.new(AssessorsGateway::UnregisteredPostcodeStub.new)

    expect {
      find_assessors_without_existing_postcode.execute("E10 3AD", nil)
    }.to raise_exception Errors::PostcodeNotRegistered
  end

  it "raises an error when the postcode is not valid" do
    find_assessor_without_valid_postcode =
      described_class.new(AssessorsGateway::InvalidPostcodesStub.new)

    expect {
      find_assessor_without_valid_postcode.execute("E19 0GL", nil)
    }.to raise_exception Errors::PostcodeNotValid
  end

  context "when there are no assessors matched by the postcode" do
    let(:assessors_gateway) { AssessorsGateway::EmptyStub.new }
    let(:find_assessor) { described_class.new(assessors_gateway) }

    it "returns empty array" do
      expect(find_assessor.execute("SW1A+2AA", nil)[:data][:assessors]).to eq([])
    end
  end

  context "when there are assessors matched by the postcode" do
    let(:valid_assessors) do
      [
        {
          "firstName": "Gregg",
          "lastName": "Sellen",
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
          "firstName": "Juliet",
          "lastName": "Montague",
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
      expect(find_assessor.execute("SW1A+2AB", nil)[:data][:assessors]).to eq(
        valid_assessors,
      )
    end

    it "returns list of assessors when the postcode includes leading or trailing whitespaces" do
      expect(find_assessor.execute(" SW1A+2AB ", nil)[:data][:assessors]).to eq(
        valid_assessors,
      )
    end
  end
end
