# frozen_string_literal: true

describe "Helpers.related_assessments", type: :helper do
  let(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "with site services" do
    let(:assessment) do
      {
        relatedAssessments: [
          {
            "assessmentId": "9273-1041-0269-0300-1496",
            "assessmentStatus": "ENTERED",
            "assessmentType": "DEC-RR",
            "assessmentExpiryDate": "2017-09-29",
          },
          {
            "assessmentId": "9273-1041-0269-0300-1497",
            "assessmentStatus": "EXPIRED",
            "assessmentType": "RdSAP",
            "assessmentExpiryDate": "2017-09-29",
          },
        ],
      }
    end

    it "does show the related assessment for DEC-RR" do
      expect(
        frontend_service_helpers.related_assessments(assessment, "DEC-RR"),
      ).to eq(
        [
          {
            "assessmentId": "9273-1041-0269-0300-1496",
            "assessmentStatus": "ENTERED",
            "assessmentType": "DEC-RR",
            "assessmentExpiryDate": "2017-09-29",
          },
        ],
      )
    end

    it "does show the related assessment for RdSAP" do
      expect(
        frontend_service_helpers.related_assessments(assessment, "RdSAP"),
      ).to eq(
        [
          {
            "assessmentId": "9273-1041-0269-0300-1497",
            "assessmentStatus": "EXPIRED",
            "assessmentType": "RdSAP",
            "assessmentExpiryDate": "2017-09-29",
          },
        ],
      )
    end

    it "does show an empty array for nonexistant type" do
      expect(
        frontend_service_helpers.related_assessments(assessment, "CEPC"),
      ).to eq []
    end
  end
end
