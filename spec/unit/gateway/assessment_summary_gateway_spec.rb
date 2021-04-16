
# frozen_string_literal: true

describe Gateway::AssessmentSummaryGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new
  end

  context "when a user searches for an assessment using the /summary endpoint" do
    let(:response) { gateway.fetch("0000-0000-0000-0000-0666") }
    context "and a certificate exists for the assessment id" do
      let(:certificate) { response[:data] }

      before { FetchAssessmentSummary::AssessmentStub.fetch_rdsap("0000-0000-0000-0000-0666") }

      it "returns the requested certificate from the api" do
        expect(certificate[:assessmentId]).to eq("0000-0000-0000-0000-0666")
      end

      it "returns the expected keys in the certificate" do
        expect(certificate.keys).to contain_exactly(
                                      :assessor,
                                      :assessmentId,
                                      :dateRegistered,
                                      :dateOfExpiry,
                                      :dateOfAssessment,
                                      :dwellingType,
                                      :typeOfAssessment,
                                      :totalFloorArea,
                                      :currentEnergyEfficiencyRating,
                                      :currentEnergyEfficiencyBand,
                                      :currentCarbonEmission,
                                      :potentialCarbonEmission,
                                      :potentialEnergyEfficiencyRating,
                                      :potentialEnergyEfficiencyBand,
                                      :postcode,
                                      :primaryEnergyUse,
                                      :addressLine1,
                                      :addressLine2,
                                      :addressLine3,
                                      :addressLine4,
                                      :town,
                                      :estimatedEnergyCost,
                                      :potentialEnergySaving,
                                      :heatDemand,
                                      :recommendedImprovements,
                                      :relatedPartyDisclosureText,
                                      :relatedPartyDisclosureNumber,
                                      :propertySummary,
                                      :greenDealPlan,
                                      :relatedAssessments,
                                      )
      end
    end
  end
end
