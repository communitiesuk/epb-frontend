describe Sinatra::FrontendService::Helpers do
  include RSpecFrontendServiceMixin

  class HelpersStub
    include Sinatra::FrontendService::Helpers
  end

  let(:assessment) do
    {
      "address": {
        "addressId": "UPRN-000000010000",
        "addressLine1": "",
        "addressLine2": "Important Person & Second Important Person",
        "addressLine3": "20 - 22 Upping Street",
        "addressLine4": "Another Address Line",
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "DEC",
      "technicalInformation": {
        "occupier": "Important Person & Second Important Person",
      },
    }
  end

  let(:assessment_without_occupier) do
    {
      "address": {
        "addressId": "UPRN-000000010000",
        "addressLine1": "",
        "addressLine2": "Important Person & Second Important Person",
        "addressLine3": "20 - 22 Upping Street",
        "addressLine4": "Another Address Line",
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "CEPC",
      "technicalInformation": {},
    }
  end

  let(:assessment_without_technicalInformation) do
    {
      "address": {
        "addressId": "UPRN-000000010000",
        "addressLine1": "",
        "addressLine2": "Important Person & Second Important Person",
        "addressLine3": "20 - 22 Upping Street",
        "addressLine4": "Another Address Line",
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "RdSAP",
    }
  end

  let(:assessment_with_one_address_line) do
    {
      "address": {
        "addressId": "UPRN-000000010000",
        "addressLine1": "First Line",
        "addressLine2": nil,
        "addressLine3": nil,
        "addressLine4": nil,
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "DEC",
      "technicalInformation": {
        "occupier": "Important Person & Second Important Person",
      },
    }
  end

  let(:assessment_with_no_address_lines) do
    {
      "address": {
        "addressId": "UPRN-000000010000",
        "addressLine1": "",
        "addressLine2": nil,
        "addressLine3": nil,
        "addressLine4": nil,
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "DEC",
      "technicalInformation": {
        "occupier": "Important Person & Second Important Person",
      },
    }
  end

  context "when compacting address for email subject line in share component" do
    it "will return the first address lines that aren't empty & isn't a duplicate occupier value" do
      response = HelpersStub.new.find_address_lines_only(assessment)
      expect(response).to eq("20 - 22 Upping Street, Another Address Line")
    end

    it "returns first two non empty address lines from certs without an occupier value" do
      response =
        HelpersStub.new.find_address_lines_only(assessment_without_occupier)
      expect(response).to eq(
        "Important Person & Second Important Person, 20 - 22 Upping Street",
      )
    end

    it "returns first two non empty address lines from certs without a technicalInformation value" do
      response =
        HelpersStub.new.find_address_lines_only(
          assessment_without_technicalInformation,
        )
      expect(response).to eq(
        "Important Person & Second Important Person, 20 - 22 Upping Street",
      )
    end

    it "returns the one valid address line" do
      response =
        HelpersStub.new.find_address_lines_only(
          assessment_with_one_address_line,
        )
      expect(response).to eq("First Line")
    end

    it "handles empty address lines from certs" do
      response =
        HelpersStub.new.find_address_lines_only(
          assessment_with_no_address_lines,
        )
      expect(response).to eq("")
    end
  end
end
