# frozen_string_literal: true

describe Gateway::CertificatesGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context "when a certificate exist" do
    let(:response) { gateway.search_by_postcode("SW1A 2AA", %w[RdSAP SAP]) }
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
        :addressLine1,
        :town,
        :greenDealPlan,
      )
    end
  end

  context "when a certificate doesnt exist" do
    let(:response) { gateway.search_by_postcode("BF1 3AA", %w[RdSAP SAP]) }

    before { FindCertificate::NoCertificatesStub.search_by_postcode }

    it "returns empty results" do
      expect(response).to eq(
        data: { assessments: [] }, meta: { searchPostcode: "BF1 3AA" },
      )
    end
  end

  context "when an assessment does exist" do
    let(:assessment_id) { "2345-6789-2345-6789-2345" }

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
        potentialEnergySaving: "174.00",
        estimatedEnergyCost: "689.83",
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
            name: "wall", description: "Many walls", energyEfficiencyRating: 2
          },
          {
            name: "secondary_heating",
            description: "Heating the house",
            energyEfficiencyRating: 5,
          },
          {
            name: "main_heating",
            description: "Room heaters, electric",
            energyEfficiencyRating: 3,
          },
        ],
        greenDealPlan: {
          "greenDealPlanId": "ABC123456DEF",
          "startDate": "2020-01-30",
          "endDate": "2030-02-28",
          "providerDetails": {
            "name": "The Bank",
            "telephone": "0800 0000000",
            "email": "lender@example.com",
          },
          "interest": { "rate": 12.3, "fixed": true },
          "chargeUplift": { "amount": 1.25, "date": "2025-03-29" },
          "ccaRegulated": true,
          "structureChanged": false,
          "measuresRemoved": false,
          "measures": [
            {
              "sequence": 0,
              "measureType": "Loft insulation",
              "product": "WarmHome lagging stuff (TM)",
              "repaidDate": "2025-03-29",
            },
          ],
          "charges": [
            {
              "sequence": 0,
              "startDate": "2020-03-29",
              "endDate": "2030-03-29",
              "dailyCharge": "0.34",
            },
          ],
          "savings": [
            { fuelCode: "39", fuelSaving: 23_253, standingChargeFraction: 0 },
            { fuelCode: "40", fuelSaving: -6331, standingChargeFraction: -0.9 },
            { fuelCode: "41", fuelSaving: -15_561, standingChargeFraction: 0 },
          ],
          estimatedSavings: 1566,
        },
        relatedAssessments: [
          {
            assessmentExpiryDate: "2006-05-04",
            assessmentId: "0000-0000-0000-0000-0001",
            assessmentStatus: "EXPIRED",
            assessmentType: "CEPC",
          },
          {
            assessmentExpiryDate: "2002-07-01",
            assessmentId: "0000-0000-0000-0000-0002",
            assessmentStatus: "EXPIRED",
            assessmentType: "CEPC-RR",
          },
        ],
      )
    end
  end

  context "when an assessment doesnt exist" do
    let(:response) { gateway.fetch("1234-5678-1234-5678-1234") }

    before do
      FetchCertificate::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    it "returns not found error" do
      expect(response).to eq(
        "errors": [{ "code": "NOT_FOUND", "title": "Assessment not found" }],
      )
    end
  end
end
