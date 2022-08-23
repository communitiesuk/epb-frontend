# frozen_string_literal: true

describe UseCase::FindNonDomesticAssessorByPostcode do
  it "returns an error when the postcode doesnt exist" do
    find_non_domestic_assessors_without_existing_postcode =
      described_class.new(AssessorsGateway::UnregisteredPostcodeStub.new)

    expect {
      find_non_domestic_assessors_without_existing_postcode.execute("E10 3AD")
    }.to raise_exception Errors::PostcodeNotRegistered
  end

  it "returns an error when the API returns that the postcode is not valid" do
    find_non_domestic_assessors_without_valid_postcode =
      described_class.new(AssessorsGateway::InvalidPostcodesStub.new)

    expect {
      find_non_domestic_assessors_without_valid_postcode.execute("H0H H0H")
    }.to raise_exception Errors::PostcodeNotValid
  end

  context "when is invalid in a manner handled by frontend validation" do
    let(:use_case) { described_class.new assessors_gateway }
    let(:assessors_gateway) do
      gateway = instance_double Gateway::AssessorsGateway
      allow(gateway).to receive :search_by_postcode
      gateway
    end

    context "with the postcode incomplete" do
      it "raises a postcode incomplete error without calling on the gateway" do
        expect {
          use_case.execute("OX4")
        }.to raise_exception Errors::PostcodeIncomplete
        expect(assessors_gateway).not_to have_received :search_by_postcode
      end
    end

    context "with the postcode in the wrong format" do
      it "raises a postcode wrong format error without calling on the gateway" do
        expect {
          use_case.execute("SW1A 2AAA")
        }.to raise_exception Errors::PostcodeWrongFormat
        expect(assessors_gateway).not_to have_received :search_by_postcode
      end
    end

    context "with the postcode in an invalid format" do
      it "raises a postcode not valid error without calling on the gateway" do
        expect {
          use_case.execute("SW1% 2AA")
        }.to raise_exception Errors::PostcodeNotValid
        expect(assessors_gateway).not_to have_received :search_by_postcode
      end
    end
  end

  context "when there are no assessors matched by the postcode" do
    let(:assessors_gateway) { AssessorsGateway::EmptyStub.new }
    let(:find_non_domestic_assessor) { described_class.new(assessors_gateway) }

    it "returns empty array" do
      expect(
        find_non_domestic_assessor.execute("SW1A 2AA")[:data][:assessors],
      ).to eq([])
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
          "qualifications": {
            "nonDomesticSp3": "ACTIVE",
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
          "qualifications": {
            "nonDomesticSp3": "ACTIVE",
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

    let(:assessors_gateway) { AssessorsGateway::NonDomesticStub.new }
    let(:find_non_domestic_assessor) { described_class.new(assessors_gateway) }

    it "returns list of non domestic assessors" do
      expect(
        find_non_domestic_assessor.execute("SW1A 2AB")[:data][:assessors],
      ).to eq(valid_assessors)
    end

    it "returns list of non domestic assessors when the postcode includes leading or trailing whitespaces" do
      expect(
        find_non_domestic_assessor.execute(" SW1A 2AB ")[:data][:assessors],
      ).to eq(valid_assessors)
    end
  end
end
