# frozen_string_literal: true

describe UseCase::FindCertificateById do
  context "when there are no certificates by that certificate number" do
    let(:certificates_gateway) { CertificatesGateway::EmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it "raises CertificateNotFound error" do
      expect {
        find_certificate.execute("4567-6789-4567-6789-4567")[:data][
          :assessments,
        ]
      }.to raise_error(Errors::CertificateNotFound)
    end
  end

  context "when there are certificates with that certificate number" do
    let(:valid_certificates) do
      [
        {
          assessmentId: "1234-5678-1234-5678-1234",
          dateOfAssessment: "2020-01-01",
          dateRegistered: "2020-01-02",
          dwellingType: "Top floor flat",
          typeOfAssessment: "RdSAP",
          totalFloorArea: 50,
          currentEnergyEfficiencyRating: 90,
          currentEnergyEfficiencyBand: "b",
          potentialEnergyEfficiencyRating: 95,
          potentialEnergyEfficiencyBand: "a",
          postcode: "SW1B 2BB",
          dateOfExpiry: "2032-01-01",
          relatedPartyDisclosureText: nil,
          relatedPartyDisclosureNumber: 2,
          heatDemand: {
            currentSpaceHeatingDemand: 222,
            currentWaterHeatingDemand: 321,
            impactOfLoftInsulation: 79,
            impactOfCavityInsulation: 67,
            impactOfSolidWallInsulation: 69,
          },
        },
      ]
    end

    let(:certificates_gateway) { CertificatesGateway::Stub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it "returns list of certificates" do
      expect(
        find_certificate.execute("4567-6789-4567-6789-4567")[:data][
          :assessments,
        ],
      ).to eq(valid_certificates)
    end
  end
end
