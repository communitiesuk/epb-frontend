# frozen_string_literal: true

describe Sinatra::FrontendService::Helpers do
  class HelpersStub
    include Sinatra::FrontendService::Helpers
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
      expect(HelpersStub.new.related_assessments(assessment, "DEC-RR")).to eq(
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
      expect(HelpersStub.new.related_assessments(assessment, "RdSAP")).to eq(
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
      expect(HelpersStub.new.related_assessments(assessment, "CEPC")).to eq []
    end
  end
end
