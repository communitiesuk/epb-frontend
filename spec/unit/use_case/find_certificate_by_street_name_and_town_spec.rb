# frozen_string_literal: true

describe UseCase::FindCertificateByStreetNameAndTown do
  include RSpecUnitMixin

  context "when there are missing parameters" do
    let(:certificates_gateway) { CertificatesGateway::EmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it "raises an error when both are missing" do
      expect { find_certificate.execute("", "", %w[RdSAP SAP]) }.to raise_error(
        Errors::AllParamsMissing,
      )
    end

    it "raises an error when street name is missing" do
      expect {
        find_certificate.execute("", "Nowhere Special", %w[RdSAP SAP])
      }.to raise_error(Errors::StreetNameMissing)
    end

    it "raises an error when town is missing" do
      expect {
        find_certificate.execute("Somewhere Empty", "", %w[RdSAP SAP])
      }.to raise_error(Errors::TownMissing)
    end
  end

  context "when there are no certificates by that street name and town" do
    let(:certificates_gateway) { CertificatesGateway::EmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it "returns empty array" do
      expect {
        find_certificate.execute("Somewhere Empty", "Nowhere Special", %w[RdSAP SAP])
      }.to raise_error(Errors::CertificateNotFound)
    end
  end

  context "when there are certificates with that street name and town" do
    let(:valid_certificates) do
      {
        "RRN-4567-6789-4567-6789-4567": {
          addressLine1: "Marsham Street",
          addressLine2: nil,
          addressLine3: nil,
          addressLine4: nil,
          postcode: "SW1B 2BB",
          town: "London",
          certificates: [
            {
              assessmentId: "4567-6789-4567-6789-4567",
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
              addressLine1: "Marsham Street",
              town: "London",
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
          ],
        },
        "RRN-1234-5678-9101-1122-1234": {
          addressLine1: "Marsham Street",
          addressLine2: nil,
          addressLine3: nil,
          addressLine4: nil,
          postcode: "SW1B 2BB",
          town: "London",
          certificates: [
            {
              assessmentId: "1234-5678-9101-1122-1234",
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
              addressLine1: "Marsham Street",
              town: "London",
              relatedPartyDisclosureText: "No related party",
              relatedPartyDisclosureNumber: nil,
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69,
              },
            },
          ],
        },
        "RRN-1234-5678-9101-1123-1234": {
          addressLine1: "Marsham Street",
          addressLine2: nil,
          addressLine3: nil,
          addressLine4: nil,
          postcode: "SW1B 2BB",
          town: "London",
          certificates: [
            {
              assessmentId: "1234-5678-9101-1123-1234",
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
              addressLine1: "Marsham Street",
              town: "London",
              relatedPartyDisclosureText: nil,
              relatedPartyDisclosureNumber: 1,
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69,
              },
            },
          ],
        },
      }
    end

    let(:certificates_gateway) { CertificatesGateway::Stub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it "returns list of certificates for correctly formatted street and town" do
      expect(
        find_certificate.execute("Marsham Street", "London", %w[RdSAP SAP])[:data][:assessments],
      ).to eq(valid_certificates)
    end

    it "returns list of certificates when street/town include leading or trailing whitespaces" do
      expect(
        find_certificate.execute(" Marsham Street", " London ", %w[RdSAP SAP])[:data][:assessments],
      ).to eq(valid_certificates)
    end
  end

  context "when there are too many results" do
    let(:internal_api_client) { get_api_client }
    let(:gateway) { Gateway::CertificatesGateway.new(internal_api_client) }
    let(:use_case) { described_class.new(gateway) }

    before do
      CertificatesGateway::TooManyResultsStub.search_by_street_name_and_town("1", "London", assessment_types: %w[RdSAP SAP])
    end

    it "raises a too many results error" do
      expect { use_case.execute("1", "London", %w[RdSAP SAP]) }.to raise_error Errors::TooManyResults
    end
  end
end
