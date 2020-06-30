# frozen_string_literal: true

module FetchCertificate
  class NonDomesticStub
    def self.fetch(
      assessment_id:,
      current_rating: 35,
      current_band: "b",
      type_of_assessment: "CEPC"
    )
      body = {
        data: {
          assessmentId: assessment_id,
          dateRegistered: "2020-01-05",
          dateOfExpiry: "2030-01-05",
          dateOfAssessment: "2020-01-02",
          typeOfAssessment: type_of_assessment,
          currentEnergyEfficiencyRating: current_rating,
          currentEnergyEfficiencyBand: current_band,
          postcode: "SW1B 2BB",
          addressLine1: "Flat 33",
          addressLine2: "2 Marsham Street",
          addressLine3: "",
          addressLine4: "",
          town: "London",
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}",
      ).to_return(status: 200, body: body.to_json)
    end
  end
end
