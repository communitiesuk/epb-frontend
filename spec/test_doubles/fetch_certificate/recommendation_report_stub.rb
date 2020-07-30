# frozen_string_literal: true

module FetchCertificate
  class RecommendationReportStub
    def self.fetch(
      assessment_id:,
      type_of_assessment: "CEPC-RR",
      linked_to_cepc: nil,
      date_of_expiry: nil,
      related_party_disclosure_text: nil
    )
      body = {
        data: {
          assessmentId: assessment_id,
          dateRegistered: "2020-01-05",
          dateOfExpiry: date_of_expiry || "2030-01-05",
          dateOfAssessment: "2020-01-02",
          typeOfAssessment: type_of_assessment,
          postcode: "SW1B 2BB",
          addressLine1: "Flat 33",
          addressLine2: "2 Marsham Street",
          addressLine3: "",
          addressLine4: "",
          town: "London",
          relatedPartyDisclosureText: related_party_disclosure_text || nil,
          assessor: {
            firstName: "John",
            lastName: "Howard",
            middleNames: "T",
            registeredBy: { name: "TEST Ltd", schemeId: 2 },
            schemeAssessorId: "TEST000000",
            searchResultsComparisonPostcode: "LU3 3UD",
            address: {},
            companyDetails: {
              companyRegNo: "",
              companyAddressLine1: "Lloyds House",
              companyAddressLine2: "18 Lloyd Street",
              companyAddressLine3: "",
              companyTown: "Manchester",
              companyPostcode: "M2 5WA",
              companyWebsite: "",
              companyTelephoneNumber: "",
              companyEmail: "",
              companyName: "Viridian Consulting Engineers Ltd",
            },
          },
          relatedAssessments: [
            {
              assessmentId: "8411-8264-4325-3608-3503",
              assessmentStatus: "ENTERED",
              assessmentType: "SAP",
              assessmentExpiryDate: "2031-05-04",
            },
            {
              assessmentId: "8411-8264-4322-3608-3503",
              assessmentStatus: "ENTERED",
              assessmentType: "CEPC",
              assessmentExpiryDate: "2030-05-04",
            },
            {
              assessmentId: "3411-8465-4422-3628-3503",
              assessmentStatus: "EXPIRED",
              assessmentType: "CEPC-RR",
              assessmentExpiryDate: "2010-05-04",
            },
          ],
          nonDomCepcRr: {
            relatedCepcReportAssessmentId: linked_to_cepc,
            technicalInformation: {
              buildingEnvironment: "Heating and Natural Ventilation",
              totalFloorArea: 935.0,
              calculationTool: "CLG, iSBEM, v5.4.b, SBEM, v5.4.b.0",
            },
            recommendations: {
              longPaybackRecommendation: [
                {
                  recommendation:
                    "Consider installing an air source heat pump.",
                  carbonImpact: "HIGH",
                },
              ],
              otherPaybackRecommendation: [
                {
                  recommendation: "Consider installing PV.",
                  carbonImpact: "HIGH",
                },
              ],
              shortPaybackRecommendation: [
                {
                  recommendation:
                    "Consider replacing T8 lamps with retrofit T5 conversion kit.",
                  carbonImpact: "HIGH",
                },
                {
                  recommendation:
                    "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
                  carbonImpact: "LOW",
                },
              ],
              mediumPaybackRecommendation: [
                {
                  recommendation:
                    "Add optimum start/stop to the heating system.",
                  carbonImpact: "MEDIUM",
                },
              ],
            },
          },
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}",
      ).to_return(status: 200, body: body.to_json)
    end
  end
end
