# frozen_string_literal: true

describe Gateway::AssessmentSummaryGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  context "when a user searches for an assessment using the /summary endpoint" do
    let(:response) { gateway.fetch("0000-0000-0000-0000-0666") }

    context "with a certificate that exists for the assessment id" do
      let(:certificate) { response[:data] }

      before do
        FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
          assessment_id: "0000-0000-0000-0000-0666",
        )
      end

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
          :address,
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
          :addendum,
          :lzcEnergySources,
        )
      end
    end

    context "with a certificate that does not exist for the assessment id" do
      before do
        FetchAssessmentSummary::NoAssessmentStub.fetch(
          "0000-0000-0000-0000-0666",
        )
      end

      it "returns a 404 NOT_FOUND error" do
        expect(response).to eq(
          "errors": [{ "code": "NOT_FOUND", "title": "Assessment not found" }],
        )
      end
    end

    context "with a certificate that is marked CANCELLED or NOT_FOR_ISSUE" do
      before do
        FetchAssessmentSummary::GoneAssessmentStub.fetch(
          "0000-0000-0000-0000-0666",
        )
      end

      it "returns a 410 GONE error" do
        expect(response).to eq(
          "errors": [
            { "code": "GONE", "title": "Assessment marked not for issue" },
          ],
        )
      end
    end
  end
end
