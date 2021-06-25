# frozen_string_literal: true

describe Gateway::AssessorsGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  context "when searching by postcode" do
    context "when an assessor exist" do
      let(:response) { gateway.search_by_postcode("SW1A 2AA") }

      let(:assessor) { response[:data][:assessors].first }

      before { FindAssessor::ByPostcode::Stub.search_by_postcode("SW1A 2AA") }

      it "checks the number of assessors returned from the api" do
        expect(response[:data][:assessors].count).to eq(7)
      end

      it "checks the shape of the object passed in the results object" do
        expect(response[:data].keys).to contain_exactly(:assessors)
      end

      it "checks the shape of the object passed in the assessor object" do
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

      it "checks the shape of the object passed in the contact details object" do
        expect(assessor[:contactDetails].keys).to contain_exactly(
          :email,
          :telephoneNumber,
        )
      end

      it "checks the shape of the object passed in the registeredBy object" do
        expect(assessor[:registeredBy].keys).to contain_exactly(
          :name,
          :schemeId,
        )
      end
    end

    context "when an assessor doesnt exist" do
      let(:response) { gateway.search_by_postcode("BF1 3AA") }

      before { FindAssessor::ByPostcode::NoAssessorsStub.search_by_postcode }

      it "returns empty results" do
        expect(response).to eq(
          data: {
            assessors: [],
          },
          meta: {
            searchPostcode: "BF1 3AA",
          },
        )
      end
    end

    context "when the postcode doesnt exist" do
      let(:response) { gateway.search_by_postcode("AF1 3AA") }

      before do
        FindAssessor::ByPostcode::UnregisteredPostcodeStub.search_by_postcode(
          "AF1 3AA",
        )
      end

      it "returns not found error" do
        expect(response).to eq(
          "errors": [
            {
              "code": "NOT_FOUND",
              "message": "The requested postcode is not registered",
            },
          ],
        )
      end
    end

    context "when the postcode is not valid" do
      let(:response) { gateway.search_by_postcode("1 3AA") }

      before do
        FindAssessor::ByPostcode::InvalidPostcodeStub.search_by_postcode(
          "1 3AA",
        )
      end

      it "returns invalid request error" do
        expect(response).to eq(
          "errors": [
            {
              "code": "INVALID_REQUEST",
              "title": "The requested postcode is not valid",
            },
          ],
        )
      end
    end

    context "when there is no scheme" do
      let(:response) { gateway.search_by_postcode("1 3AA") }

      before do
        FindAssessor::ByPostcode::NoSchemeStub.search_by_postcode("1 3AA")
      end

      it "returns scheme not found error" do
        expect(response).to eq(
          "errors": [
            {
              "code": "SCHEME_NOT_FOUND",
              "message": "There is no scheme for one of the requested assessor",
            },
          ],
        )
      end
    end
  end

  context "when searching by name" do
    context "when an assessor exist" do
      let(:response) { gateway.search_by_name("Some Name") }

      let(:assessor) { response[:data][:assessors].first }

      before { FindAssessor::ByName::Stub.search_by_name("Some Name") }

      it "checks the number of assessors returned from the api" do
        expect(response[:data][:assessors].count).to eq(8)
      end

      it "checks the shape of the object passed in the assessor object" do
        expect(assessor.keys).to contain_exactly(
          :firstName,
          :lastName,
          :contactDetails,
          :searchResultsComparisonPostcode,
          :registeredBy,
          :schemeAssessorId,
        )
      end

      it "checks the shape of the object passed in the contact details object" do
        expect(assessor[:contactDetails].keys).to contain_exactly(
          :email,
          :telephoneNumber,
        )
      end

      it "checks the shape of the object passed in the registeredBy object" do
        expect(assessor[:registeredBy].keys).to contain_exactly(
          :name,
          :schemeId,
        )
      end
    end

    context "when an assessor doesnt exist" do
      let(:response) { gateway.search_by_name("Some Nonexistent-name") }

      before do
        FindAssessor::ByName::NoAssessorsStub.search_by_name(
          "Some Nonexistent-name",
        )
      end

      it "returns empty results" do
        expect(response).to eq(
          data: {
            assessors: [],
          },
          meta: {
            searchName: "Some Nonexistent-name",
            looseMatch: false,
          },
        )
      end
    end
  end
end
