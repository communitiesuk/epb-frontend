# frozen_string_literal: true

describe Gateway::CertificatesGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  describe "for the search by postcode gateway" do
    context "when a certificate exists" do
      let(:response) { gateway.search_by_postcode("SW1A 2AA", %w[RdSAP SAP]) }
      let(:certificate) { response[:data][:assessments].first }

      before { FindCertificate::Stub.search_by_postcode("SW1A 2AA") }

      it "checks the number of certificates returned from the api" do
        expect(response[:data][:assessments].count).to eq(4)
      end

      it "checks the shape of the object passed in the certificate object" do
        expect(certificate.keys).to match_array %i[
          assessmentId
          addressId
          dateOfAssessment
          dateOfRegistration
          typeOfAssessment
          currentEnergyEfficiencyRating
          currentEnergyEfficiencyBand
          optOut
          dateOfExpiry
          addressLine1
          addressLine2
          addressLine3
          addressLine4
          town
          postcode
          status
        ]
      end
    end

    context "when a certificate doesnt exist" do
      let(:response) { gateway.search_by_postcode("BF1 3AA", %w[RdSAP SAP]) }

      before { FindCertificate::NoCertificatesStub.search_by_postcode }

      it "returns empty results" do
        expect(response).to eq(
          data: {
            assessments: [],
          },
          meta: {
            searchPostcode: "BF1 3AA",
          },
        )
      end
    end
  end

  describe "for the fetch dec summary gateway" do
    context "when a certificate is unsupported" do
      let(:response) { gateway.fetch_dec_summary("0000-0000-0000-0000-1111") }

      before do
        CertificatesGateway::UnsupportedSchemaStub.fetch_dec_summary(
          "0000-0000-0000-0000-1111",
        )
      end

      it "returns not found error" do
        expect(response).to eq(
          "errors": [
            { "code": "INVALID_REQUEST", "message": "Unsupported schema type" },
          ],
        )
      end
    end
  end
end
