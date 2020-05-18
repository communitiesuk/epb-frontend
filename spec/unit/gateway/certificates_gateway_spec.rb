# frozen_string_literal: true

describe Gateway::CertificatesGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context "when a certificate exist" do
    let(:response) { gateway.search_by_postcode("SW1A 2AA") }
    let(:certificate) { response[:data][:assessments].first }

    before { FindCertificate::Stub.search_by_postcode("SW1A 2AA") }

    it "checks the number of certificates returned from the api" do
      expect(response[:data][:assessments].count).to eq(3)
    end

    it "checks the shape of the object passed in the certificate object" do
      expect(certificate.keys).to contain_exactly(
        :assessmentId,
        :dateOfAssessment,
        :dateRegistered,
        :dwellingType,
        :typeOfAssessment,
        :totalFloorArea,
        :addressSummary,
        :currentCarbonEmission,
        :potentialCarbonEmission,
        :currentEnergyEfficiencyRating,
        :currentEnergyEfficiencyBand,
        :potentialEnergyEfficiencyRating,
        :potentialEnergyEfficiencyBand,
        :postcode,
        :dateOfExpiry,
        :heatDemand,
        :recommendedImprovements,
        :propertySummary,
      )
    end
  end

  context "when a certificate doesnt exist" do
    let(:response) { gateway.search_by_postcode("BF1 3AA") }

    before { FindCertificate::NoCertificatesStub.search_by_postcode }

    it "returns empty results" do
      expect(response).to eq(
        data: { assessments: [] }, meta: { searchPostcode: "BF1 3AA" },
      )
    end
  end

  context "when an assessment does exist" do
    let(:assessment_id) { "223-456" }

    before { FetchCertificate::Stub.fetch(assessment_id) }

    it "returns assessments" do
      result = gateway.fetch(assessment_id)

      expect(result[:data]).to eq(
        assessor: {
          firstName: "Test",
          lastName: "Boi",
          registeredBy: { name: "Elmhurst Energy", schemeId: 1 },
          schemeAssessorId: "TESTASSESSOR",
          dateOfBirth: "2019-12-04",
          contactDetails: {
            telephoneNumber: "12345678901", email: "test.boi@quidos.com"
          },
          searchResultsComparisonPostcode: "SW1A 2AA",
          qualifications: { domesticRdSap: "ACTIVE" },
        },
        addressSummary: "Flat 33, 2 Marsham Street, London, SW1B 2BB",
        assessmentId: assessment_id,
        dateOfAssessment: "02 January 2020",
        dateRegistered: "05 January 2020",
        dateOfExpiry: "05 January 2030",
        dwellingType: "Top floor flat",
        typeOfAssessment: "RdSAP",
        totalFloorArea: 150,
        currentCarbonEmission: 2.4,
        potentialCarbonEmission: 1.4,
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
        heatDemand: {
          currentSpaceHeatingDemand: 222,
          currentWaterHeatingDemand: 321,
          impactOfLoftInsulation: 79,
          impactOfCavityInsulation: 67,
          impactOfSolidWallInsulation: 69,
        },
        recommendedImprovements: [],
        relatedPartyDisclosureText: nil,
        relatedPartyDisclosureNumber: 1,
        propertySummary: [
          {
            name: "Walls", description: "Many walls", energyEfficiencyRating: 2
          },
          {
            name: "secondary_heating",
            description: "Heating the house",
            energyEfficiencyRating: 5,
          },
          {
            name: "MainHeating",
            description: "Room heaters, electric",
            energyEfficiencyRating: 3,
          },
        ],
      )
    end
  end

  context "when an assessment doesnt exist" do
    let(:response) { gateway.fetch("123-456") }

    before { FetchCertificate::NoAssessmentStub.fetch("123-456") }

    it "returns not found error" do
      expect(response).to eq(
        "errors": [{ "code": "NOT_FOUND", "title": "Assessment not found" }],
      )
    end
  end
end
