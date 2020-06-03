# frozen_string_literal: true

describe UseCase::FetchCertificate do
  include RSpecUnitMixin

  context "when an assessment doesnt exist" do
    let(:certificates_gateway) { CertificatesGateway::NoAssessmentStub.new }
    let(:fetch_certificate) { described_class.new(certificates_gateway) }

    it "raises an AssessmentNotFound error" do
      expect { fetch_certificate.execute("123-456") }.to raise_error(
        Errors::AssessmentNotFound,
      )
    end
  end

  context "when an assessment does exist" do
    let(:certificates_gateway) { CertificatesGateway::Stub.new }
    let(:fetch_certificate) { described_class.new(certificates_gateway) }

    it "returns assessments" do
      result = fetch_certificate.execute("223-456")[:data]
      expect(result).to eq(
        assessor: {
          firstName: "Test",
          lastName: "Boi",
          registeredBy: { name: "Quidos", schemeId: 1 },
          schemeAssessorId: "TESTASSESSOR",
          dateOfBirth: "2019-12-04",
          contactDetails: {
            telephoneNumber: "12345678901", email: "test.boi@quidos.com"
          },
          searchResultsComparisonPostcode: "SW1A 2AA",
          qualifications: { domesticRdSap: "ACTIVE" },
        },
        assessmentId: "223-456",
        dateOfAssessment: "02 January 2020",
        dateRegistered: "05 January 2020",
        dateOfExpiry: "05 January 2030",
        dwellingType: "Top floor flat",
        typeOfAssessment: "RdSAP",
        totalFloorArea: 150,
        currentEnergyEfficiencyRating: 90,
        currentEnergyEfficiencyBand: "b",
        potentialEnergyEfficiencyRating: 99,
        potentialEnergyEfficiencyBand: "a",
        postcode: "SW1B 2BB",
        addressLine1: "Flat 33",
        addressLine2: "2 Marsham Street",
        addressLine3: "",
        addressLine4: "",
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
        recommendedImprovements: [],
      )
    end
  end

  context "when an assessment does exist with recommendations" do
    let(:certificates_gateway) { CertificatesGateway::Stub.new(true) }
    let(:fetch_certificate) { described_class.new(certificates_gateway) }

    it "returns assessments with sorted recommendations " do
      result = fetch_certificate.execute("223-455")[:data]
      expect(result).to eq(
        assessor: {
          firstName: "Test",
          lastName: "Boi",
          registeredBy: { name: "Quidos", schemeId: 1 },
          schemeAssessorId: "TESTASSESSOR",
          dateOfBirth: "2019-12-04",
          contactDetails: {
            telephoneNumber: "12345678901", email: "test.boi@quidos.com"
          },
          searchResultsComparisonPostcode: "SW1A 2AA",
          qualifications: { domesticRdSap: "ACTIVE" },
        },
        assessmentId: "223-455",
        dateOfAssessment: "02 January 2020",
        dateRegistered: "05 January 2020",
        dateOfExpiry: "05 January 2030",
        dwellingType: "Top floor flat",
        typeOfAssessment: "RdSAP",
        totalFloorArea: 150,
        currentEnergyEfficiencyRating: 90,
        currentEnergyEfficiencyBand: "b",
        potentialEnergyEfficiencyRating: 99,
        potentialEnergyEfficiencyBand: "a",
        postcode: "SW1B 2BB",
        addressLine1: "Flat 33",
        addressLine2: "2 Marsham Street",
        addressLine3: "",
        addressLine4: "",
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
        recommendedImprovements: [
          {
            sequence: 1,
            indicativeCost: "£500 - £1000",
            typicalSaving: 900.00,
            improvementCode: "2",
            improvementCategory: "string",
            improvementType: "string",
            energyPerformanceRating: "C",
            environmentalImpactRating: "string",
            greenDealCategoryCode: "string",
          },
          {
            sequence: 2,
            indicativeCost: "£300 - £400",
            typicalSaving: 9000.00,
            improvementCode: "3",
            improvementCategory: "string",
            improvementType: "string",
            energyPerformanceRating: "C",
            environmentalImpactRating: "string",
            greenDealCategoryCode: "string",
          },
          {
            sequence: 3,
            indicativeCost: "£200 - £500",
            typicalSaving: 100.00,
            improvementCode: "1",
            improvementCategory: "string",
            improvementType: "string",
            energyPerformanceRating: "C",
            environmentalImpactRating: "string",
            greenDealCategoryCode: "string",
          },
        ],
      )
    end
  end
end
