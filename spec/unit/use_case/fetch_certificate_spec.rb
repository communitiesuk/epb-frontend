describe UseCase::FetchCertificate do
  include RSpecUnitMixin

  context "When executing the Fetch Certificate (Summary) use case" do
    context "And there is a lodged certificate with the assessment_id" do
      let(:summary_gateway) { Gateway::AssessmentSummaryGateway.new(get_api_client) }
      let(:fetch_certificate) { described_class.new(summary_gateway) }

      let(:result) do
        { data: { addressLine1: "Flat 33",
                  addressLine2: "2 Marsham Street",
                  addressLine3: "",
                  addressLine4: "",
                  assessmentId: "0000-0000-0000-0000-0666",
                  assessor: { contactDetails: { email: "test.boi@quidos.com",
                                                telephoneNumber: "12345678901" },
                              dateOfBirth: "2019-12-04",
                              firstName: "Test",
                              lastName: "Boi",
                              qualifications: { domesticRdSap: "ACTIVE" },
                              registeredBy: { name: "Elmhurst Energy", schemeId: 1 },
                              schemeAssessorId: "TESTASSESSOR",
                              searchResultsComparisonPostcode: "SW1A 2AA" },
                  currentCarbonEmission: "2.4",
                  currentEnergyEfficiencyBand: "b",
                  currentEnergyEfficiencyRating: 90,
                  dateOfAssessment: Date.new(2020, 1, 2),
                  dateOfExpiry: Date.new(2030, 1, 5),
                  dateRegistered: Date.new(2020, 1, 5),
                  dwellingType: "Top floor flat",
                  estimatedEnergyCost: "689.83",
                  greenDealPlan: [{ ccaRegulated: true,
                                    chargeUplift: { amount: 1.25, date: "2025-03-29" },
                                    charges: [{ dailyCharge: "0.33", endDate: "2030-03-29", sequence: 0, startDate: "2020-03-29" }, { dailyCharge: "0.01", endDate: "2030-03-29", sequence: 1, startDate: "2020-03-29" }],
                                    endDate: "2030-02-28",
                                    estimatedSavings: 1566,
                                    greenDealPlanId: "ABC123456DEF",
                                    interest: { fixed: true, rate: 12.3 },
                                    measures: [{ measureType: "Loft insulation", product: "WarmHome lagging stuff (TM)", repaidDate: "2025-03-29", sequence: 0 }, { measureType: "Double glazing", product: "Not applicable", sequence: 1 }],
                                    measuresRemoved: false,
                                    providerDetails: { email: "lender@example.com", name: "The Bank", telephone: "0800 0000000" },
                                    savings: [{ fuelCode: "39", fuelSaving: 23_253, standingChargeFraction: 0 }, { fuelCode: "40", fuelSaving: -6331, standingChargeFraction: -0.9 }, { fuelCode: "41", fuelSaving: -15_561, standingChargeFraction: 0 }],
                                    startDate: "2020-01-30",
                                    structureChanged: false }],
                  heatDemand: { currentSpaceHeatingDemand: 222, currentWaterHeatingDemand: 321, impactOfCavityInsulation: -67, impactOfLoftInsulation: -79, impactOfSolidWallInsulation: -69 },
                  postcode: "SW1B 2BB",
                  potentialCarbonEmission: "1.4",
                  potentialEnergyEfficiencyBand: "a",
                  potentialEnergyEfficiencyRating: 99,
                  potentialEnergySaving: "174.00",
                  primaryEnergyUse: 989.345346,
                  propertySummary: [{ description: "Many walls", energyEfficiencyRating: 2, name: "wall" }, { description: "Heating the house", energyEfficiencyRating: 5, name: "secondary_heating" }, { description: "Room heaters, electric", energyEfficiencyRating: 3, name: "main_heating" }, { description: "(another dwelling above)", energyEfficiencyRating: 0, name: "roof" }],
                  recommendedImprovements: [],
                  relatedAssessments: [{ assessmentExpiryDate: "2006-05-04", assessmentId: "0000-0000-0000-0000-0001", assessmentStatus: "EXPIRED", assessmentType: "RdSAP" }, { assessmentExpiryDate: "2002-07-01", assessmentId: "0000-0000-0000-0000-0002", assessmentStatus: "EXPIRED", assessmentType: "CEPC-RR" }, { assessmentExpiryDate: "2030-05-04", assessmentId: "9024-0000-0000-0000-0000", assessmentStatus: "CANCELLED", assessmentType: "RdSAP" }, { assessmentExpiryDate: "2031-05-04", assessmentId: "9025-0000-0000-0000-0000", assessmentStatus: "ENTERED", assessmentType: "RdSAP" }, { assessmentExpiryDate: "2035-05-04", assessmentId: "9026-0000-0000-0000-0000", assessmentStatus: "ENTERED", assessmentType: "SAP" }],
                  relatedPartyDisclosureNumber: 1,
                  relatedPartyDisclosureText: nil,
                  totalFloorArea: "150",
                  town: "London",
                  typeOfAssessment: "RdSAP" } }
      end

      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          "0000-0000-0000-0000-0666",
        )
      end

      it "returns the certificate" do
        expect(fetch_certificate.execute("0000-0000-0000-0000-0666")).to eq(result)
      end
    end

    context "And there is a GONE certificate with an assessment_id" do
      let(:summary_gateway) { Gateway::AssessmentSummaryGateway.new(get_api_client) }
      let(:fetch_certificate) { described_class.new(summary_gateway) }

      before do
        FetchAssessmentSummary::GoneAssessmentStub.fetch("0666-0000-0000-0000-0000")
      end

      it "raises a 410 GONE error" do
        expect{ fetch_certificate.execute("0666-0000-0000-0000-0000") }.to raise_error(Errors::AssessmentGone)
      end
    end
  end
end
