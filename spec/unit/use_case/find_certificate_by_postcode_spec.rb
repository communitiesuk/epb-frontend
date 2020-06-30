# frozen_string_literal: true

describe UseCase::FindCertificateByPostcode do
  context "when there are no certificates at the postcode" do
    let(:certificates_gateway) { CertificatesGateway::EmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it "returns empty array" do
      expect(find_certificate.execute("SW1A 2AA")[:data][:assessments]).to eq(
        [],
      )
    end
  end

  context "when there are certificates at the postcode" do
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
          potentialEnergyEfficiencyRating: "a",
          potentialEnergyEfficiencyBand: 95,
          postcode: "SW1B 2BB",
          dateOfExpiry: "2030-01-01",
          relatedPartyDisclosureText: "Financial interest in the property",
          relatedPartyDisclosureNumber: nil,
          heatDemand: {
            currentSpaceHeatingDemand: 222,
            currentWaterHeatingDemand: 321,
            impactOfLoftInsulation: 79,
            impactOfCavityInsulation: 67,
            impactOfSolidWallInsulation: 69,
          },
        },
        {
          assessmentId: "3345-6789-2345-6789-2345",
          dateOfAssessment: "2020-01-01",
          dateRegistered: "2020-01-02",
          dwellingType: "Top floor flat",
          typeOfAssessment: "RdSAP",
          totalFloorArea: 50,
          currentEnergyEfficiencyRating: 90,
          currentEnergyEfficiencyBand: "b",
          potentialEnergyEfficiencyRating: "a",
          potentialEnergyEfficiencyBand: 95,
          postcode: "SW1B 2BB",
          dateOfExpiry: "2030-01-01",
          relatedPartyDisclosureText: nil,
          relatedPartyDisclosureNumber: 4,
          heatDemand: {
            currentSpaceHeatingDemand: 222,
            currentWaterHeatingDemand: 321,
            impactOfLoftInsulation: 79,
            impactOfCavityInsulation: 67,
            impactOfSolidWallInsulation: 69,
          },
        },
        {
          assessmentId: "1234-5678-1234-5678-1234",
          dateOfAssessment: "2020-01-01",
          dateRegistered: "2020-01-02",
          dwellingType: "Top floor flat",
          typeOfAssessment: "RdSAP",
          totalFloorArea: 50,
          currentEnergyEfficiencyRating: 90,
          currentEnergyEfficiencyBand: "b",
          potentialEnergyEfficiencyRating: "a",
          potentialEnergyEfficiencyBand: 95,
          postcode: "SW1B 2BB",
          dateOfExpiry: "2032-01-01",
          relatedPartyDisclosureText: "Financial interest in the property",
          relatedPartyDisclosureNumber: nil,
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
    let(:find_certificate_by_postcode) do
      described_class.new(certificates_gateway)
    end

    it "returns list of certificates" do
      expect(
        find_certificate_by_postcode.execute("SW1A 2AB")[:data][:assessments],
      ).to eq(valid_certificates)
    end
  end
end
