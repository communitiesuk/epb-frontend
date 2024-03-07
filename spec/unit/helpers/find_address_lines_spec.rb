describe "Helpers.find_address_lines_only", type: :helper do
  include RSpecFrontendServiceMixin

  let(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  let(:assessment) do
    OpenStruct.new(
      default: {
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
      },
      without_occupier: {
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
      },
      without_technical_information: {
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
      },
      with_one_address_line: {
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
      },
      with_no_address_lines: {
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
      },
    )
  end

  context "when compacting address for email subject line in share component" do
    it "returns the first address lines that aren't empty & isn't a duplicate occupier value" do
      result = frontend_service_helpers.find_address_lines_only(assessment.default)
      expect(result).to eq("20 - 22 Upping Street, Another Address Line")
    end

    it "returns first two non empty address lines from certs without an occupier value" do
      result =
        frontend_service_helpers.find_address_lines_only(
          assessment.without_occupier,
        )
      expect(result).to eq "Important Person & Second Important Person, 20 - 22 Upping Street"
    end

    it "returns first two non empty address lines from certs without a technicalInformation value" do
      result =
        frontend_service_helpers.find_address_lines_only(
          assessment.without_technical_information,
        )
      expect(result).to eq "Important Person & Second Important Person, 20 - 22 Upping Street"
    end

    it "returns the one valid address line" do
      result =
        frontend_service_helpers.find_address_lines_only(
          assessment.with_one_address_line,
        )
      expect(result).to eq("First Line")
    end

    it "handles empty address lines from certs" do
      result =
        frontend_service_helpers.find_address_lines_only(
          assessment.with_no_address_lines,
        )
      expect(result).to eq("")
    end
  end
end
