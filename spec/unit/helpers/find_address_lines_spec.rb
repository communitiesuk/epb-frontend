
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
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "DEC",
      "technicalInformation": {
      },
    }
  end

  let(:assessment_without_technicalInformation) do
    {
      "address": {
        "addressId": "UPRN-000000010000",
        "addressLine1": "",
        "addressLine2": "Important Person & Second Important Person",
        "addressLine3": "20 - 22 Upping Street",
        "town": "LONDON",
        "postcode": "A0 0AA",
      },
      "typeOfAssessment": "DEC",
    }
  end

  context "when compacting address for email subject line" do
    it "will return the first address lines that isn't empty" do
      response = HelpersStub.new.find_address_lines(assessment)
      expect(response).to eq("20 - 22 Upping Street, LONDON")
    end

    it "will return the first address lines that isn't empty" do
      reply = HelpersStub.new.find_address_lines(assessment_without_occupier)
      expect(reply).to eq("Important Person & Second Important Person, 20 - 22 Upping Street")
    end

    it "will return the first address lines that isn't empty" do
      reply = HelpersStub.new.find_address_lines(assessment_without_technicalInformation)
      expect(reply).to eq("Important Person & Second Important Person, 20 - 22 Upping Street")
    end
  end
end
