# frozen_string_literal: true

describe "Acceptance::Postcodes" do
  include RSpecUnitMixin

  let(:internal_api_client) { container.get_object(:internal_api_client) }
  let(:assessors_gateway) { Gateway::AssessorsGateway.new(internal_api_client) }
  let(:find_assessor) { UseCase::FindAssessorByPostcode.new(assessors_gateway) }

  context "given valid postcode" do
    context "where assessors are near" do
      let(:response) { find_assessor.execute("SW1A+2AA") }
      let(:assessor) { response[:data][:assessors].first }

      before { FindAssessor::ByPostcode::Stub.search_by_postcode("SW1A+2AA") }

      it "returns the number of assessors returned from the api" do
        expect(response[:data][:assessors].count).to eq(7)
      end

      it "returns response keys for results object" do
        expect(response.keys).to contain_exactly(:data, :meta)
      end

      it "returns response keys for assessor object" do
        expect(assessor.keys).to contain_exactly(
          :firstName,
          :lastName,
          :contactDetails,
          :searchResultsComparisonPostcode,
          :registeredBy,
          :schemeAssessorId,
          :qualifications,
          :distanceFromPostcodeInMiles,
        )
      end

      it "returns response keys for contactDetails object" do
        expect(assessor[:contactDetails].keys).to contain_exactly(
          :email,
          :telephoneNumber,
        )
      end

      it "returns response keys for registeredBy object" do
        expect(assessor[:registeredBy].keys).to contain_exactly(
          :name,
          :schemeId,
        )
      end
    end

    context "where no assessors are near" do
      before do
        FindAssessor::ByPostcode::NoNearAssessorsStub.search_by_postcode(
          "BF1+3AA",
        )
      end

      it "returns empty results" do
        expect(find_assessor.execute("BF1+3AA")[:data][:assessors]).to eq([])
      end
    end

    context "where the postcode doesnt exist" do
      before do
        FindAssessor::ByPostcode::UnregisteredPostcodeStub.search_by_postcode(
          "B11+4AA",
        )
      end

      it "raises postcode not registered exception" do
        expect {
          find_assessor.execute("B11+4AA")
        }.to raise_exception Errors::PostcodeNotRegistered
      end
    end

    context "where the requested postcode is malformed" do
      before do
        FindAssessor::ByPostcode::InvalidPostcodeStub.search_by_postcode(
          "C11+3FF",
        )
      end

      it "raises postcode not valid exception" do
        expect {
          find_assessor.execute("C11+3FF")
        }.to raise_exception Errors::PostcodeNotValid
      end
    end
  end
end
