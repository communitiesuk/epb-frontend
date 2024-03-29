# frozen_string_literal: true

describe Gateway::AssessorsGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  context "when searching by postcode" do
    context "when an assessor exist" do
      let(:response) { gateway.search_by_postcode("SW1A 2AA", "domesticSap,domesticRdSap") }

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
      let(:response) { gateway.search_by_postcode("BF1 3AA", "domesticSap,domesticRdSap") }

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
      let(:response) { gateway.search_by_postcode("AF1 3AA", "domesticSap,domesticRdSap") }

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
      let(:response) { gateway.search_by_postcode("1 3AA", "domesticSap,domesticRdSap") }

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
      let(:response) { gateway.search_by_postcode("1 3AA", "domesticSap,domesticRdSap") }

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
          :qualifications,
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

      it "allows to specify qualification type" do
        FindAssessor::ByName::Stub.search_by_name("Some Name", "domestic")

        expect { gateway.search_by_name("Some Name", "domestic") }.not_to raise_error
      end
    end

    context "when an assessor doesnt exist" do
      before do
        FindAssessor::ByName::NoAssessorsStub.search_by_name(
          "Some Nonexistent-name",
        )
        FindAssessor::ByName::NoAssessorsStub.search_by_name(
          "Mats Söderlund",
        )
      end

      it "returns empty results" do
        name = "Some Nonexistent-name"
        response = gateway.search_by_name(name)
        expect_empty(response, name)
      end

      it "returns empty results for name containing non ASCII characters" do
        name = "Mats Söderlund"
        response = gateway.search_by_name(name)
        expect_empty(response, name)
      end

      def expect_empty(response, search_name)
        expect(response).to eq(
          data: {
            assessors: [],
          },
          meta: {
            searchName: search_name,
            looseMatch: false,
          },
        )
      end
    end
  end
end
