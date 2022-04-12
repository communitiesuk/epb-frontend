describe "Helpers.assessment_superseded" do
  describe "Helpers.assessment_superseded?", type: :helper do
    let(:frontend_service_helpers) do
      Class.new { extend Helpers }
    end

    context "when a certificate has not been superseded by a later epc" do
      let(:assessment) do
        {
          assessmentId: "9273-1041-0269-0300-1496",
          status: "ENTERED",
          assessmentType: "DEC-RR",
          dateOfExpiry: "2027-09-29",
          relatedAssessments: [],
        }
      end

      it "returns false " do
        expect(frontend_service_helpers.assessment_superseded?(assessment)).to eq false
      end
    end

    context "when a certificate is expired but has no later certs" do
      let(:assessment) do
        {
          assessmentId: "9273-1041-0269-0300-1496",
          status: "EXPIRED",
          assessmentType: "DEC-RR",
          dateOfExpiry: "2017-09-29",
          relatedAssessments: [],
        }
      end

      it "returns false " do
        expect(frontend_service_helpers.assessment_superseded?(assessment)).to eq false
      end
    end

    context "when a certificate has later related certs " do
      let(:assessment) do
        {
          assessmentId: "9273-1041-0269-0300-1496",
          status: "ENTERED",
          assessmentType: "RdSAP",
          dateOfExpiry: "2017-09-29",
          relatedAssessments: [
            {
              "assessmentId": "9273-1041-0269-0300-1497",
              "assessmentStatus": "EXPIRED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2017-09-29",
            },

            {
              "assessmentId": "9273-1041-0269-0300-1496",
              "assessmentStatus": "ENTERED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2030-09-29",
            },

          ],
        }
      end

      it "returns true when latest related assessment is 'entered' or not expired" do
        expect(frontend_service_helpers.assessment_superseded?(assessment)).to eq true
      end

      it "returns false when all of the related certs are expired " do
        assessment =
          {
            assessmentId: "9273-1041-0269-0300-1496",
            status: "EXPIRED",
            assessmentType: "RdSAP",
            dateOfExpiry: "2017-09-29",
            relatedAssessments: [
              {
                "assessmentId": "9273-1041-0269-0300-1497",
                "assessmentStatus": "EXPIRED",
                "assessmentType": "RdSAP",
                "assessmentExpiryDate": "2017-09-29",
              },
              {
                "assessmentId": "1234-1041-0269-0300-4578",
                "assessmentStatus": "EXPIRED",
                "assessmentType": "RdSAP",
                "assessmentExpiryDate": "2022-04-10",
              },
            ],
          }

        expect(frontend_service_helpers.assessment_superseded?(assessment)).to eq false
      end
    end
  end

  describe "Helpers.get_superseded_assessment_id" do
    let(:frontend_service_helpers) do
      Class.new { extend Helpers }
    end

    context "when an assessment has many related superseded assessments" do
      let(:assessment) do
        {
          assessmentId: "9273-1041-0269-0300-1496",
          status: "ENTERED",
          assessmentType: "RdSAP",
          dateOfExpiry: "2023-09-29",
          relatedAssessments: [
            {
              "assessmentId": "0001-1041-0269-0300-1234",
              "assessmentStatus": "EXPIRED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2019-09-29",
            },
            {
              "assessmentId": "9273-1041-0269-0300-1497",
              "assessmentStatus": "ENTERED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2024-09-29",
            },
            {
              "assessmentId": "1234-1041-0269-0300-4578",
              "assessmentStatus": "ENTERED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2025-04-10",
            },
            {
              "assessmentId": "9999-1041-0269-0300-1234",
              "assessmentStatus": "ENTERED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2026-04-10",
            },
            {
              "assessmentId": "8888-1041-0269-0300-9678",
              "assessmentStatus": "ENTERED",
              "assessmentType": "RdSAP",
              "assessmentExpiryDate": "2025-12-17",
            },
          ],
        }
      end

      it "returns the assessment id for the latest valid related epc" do
        expect(frontend_service_helpers.get_superseded_assessment_id(assessment)).to eq "9999-1041-0269-0300-1234"
      end
    end
  end
end
