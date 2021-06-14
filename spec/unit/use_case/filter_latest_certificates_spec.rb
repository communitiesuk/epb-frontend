require "rspec"
require "json"

describe UseCase::FilterLatestCertificates do
  before { @usecase = UseCase::FilterLatestCertificates.new(nil) }

  context "when processing a response from domestic assessment search by postcode" do
    let(:json_response) do
      JSON.parse(get_domestic_search_by_postcode, symbolize_names: true)
    end

    let(:result) { @usecase.execute(json_response) }

    it "returns the address with the most recent certificate of any domestic type" do
      certificates = result[:"UPRN-000000000000"][:certificates]
      expect(certificates).to contain_exactly(latest_rdsap_certificate)
    end

    it "returns the address with the most recent address lines" do
      address = result[:"UPRN-000000000000"]
      expect(address[:addressLine1]).to eq "A3-L1"
      expect(address[:addressLine2]).to eq "A3-L2"
      expect(address[:addressLine3]).to eq "A3-L3"
      expect(address[:addressLine4]).to eq ""
      expect(address[:town]).to eq "LONDON"
      expect(address[:postcode]).to eq "SW1W 8ED"
    end
  end

  context "when processing a response from non-domestic assessment search by postcode" do
    let(:json_response) do
      JSON.parse(get_non_domestic_search_by_postcode, symbolize_names: true)
    end
    let(:result) { @usecase.execute(json_response) }

    it "returns the address with the most recent certificate for each type" do
      certificates = result[:"UPRN-123456789012"][:certificates]
      expect(certificates).to contain_exactly(
        latest_cepc,
        latest_cepc_rr,
        latest_dec,
        latest_dec_rr,
        latest_ac_cert,
        latest_ac_report,
      )
    end

    it "returns the address with the most recent address lines" do
      address = result[:"UPRN-123456789012"]
      expect(address[:addressLine1]).to eq "The Coolest Supershop"
      expect(address[:addressLine2]).to eq "350-354 The High Road"
      expect(address[:addressLine3]).to eq ""
      expect(address[:addressLine4]).to eq ""
      expect(address[:town]).to eq "LONDON"
      expect(address[:postcode]).to eq "SW1W 8ED"
    end
  end

private

  def latest_rdsap_certificate
    json_body =
      '{
        "dateOfAssessment": "2011-04-01",
        "typeOfAssessment": "RdSAP",
        "assessmentId": "0000-0000-0000-0000-0003",
        "currentEnergyEfficiencyRating": 55,
        "optOut": false,
        "postcode": "SW1W 8ED",
        "dateOfExpiry": "2021-03-01",
        "addressId": "UPRN-000000000000",
        "addressLine1": "A3-L1",
        "addressLine2": "A3-L2",
        "addressLine3": "A3-L3",
        "addressLine4": "",
        "town": "LONDON",
        "currentEnergyEfficiencyBand": "d",
        "status": "ENTERED"
      }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def latest_cepc
    json_body =
      '{
                "dateOfAssessment": "2020-06-12",
                "typeOfAssessment": "CEPC",
                "assessmentId": "0560-0630-5012-9408-6007",
                "currentEnergyEfficiencyRating": 40,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2030-08-08",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Limited",
                "addressLine2": "350 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "e",
                "status": "ENTERED"
            }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def latest_cepc_rr
    json_body =
      '{
                "dateOfAssessment": "2020-06-12",
                "typeOfAssessment": "CEPC-RR",
                "assessmentId": "0080-6206-0410-5540-6666",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2030-08-08",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Limited",
                "addressLine2": "350 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def latest_dec
    json_body =
      '{
                "dateOfAssessment": "2019-01-22",
                "typeOfAssessment": "DEC",
                "assessmentId": "9000-3952-0385-3610-7777",
                "currentEnergyEfficiencyRating": 130,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2025-10-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Supershop",
                "addressLine2": "350-352 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "a",
                "status": "ENTERED"
            }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def latest_dec_rr
    json_body =
      '{
                "dateOfAssessment": "2018-01-22",
                "typeOfAssessment": "DEC-RR",
                "assessmentId": "9496-4049-0585-0400-2222",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2028-02-18",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Ltd",
                "addressLine2": "350, The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def latest_ac_cert
    json_body =
      '{
                "dateOfAssessment": "2020-08-05",
                "typeOfAssessment": "AC-CERT",
                "assessmentId": "9856-6086-0413-0600-3333",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2024-06-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Coolest Supershop",
                "addressLine2": "350-354 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def latest_ac_report
    json_body =
      '{
                "dateOfAssessment": "2020-08-05",
                "typeOfAssessment": "AC-REPORT",
                "assessmentId": "0960-8949-0531-5280-7777",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2024-06-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Coolest Supershop",
                "addressLine2": "350-354 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            }'
    JSON.parse(json_body, symbolize_names: true)
  end

  def get_domestic_search_by_postcode
    '{
    "data": {
        "assessments": [
            {
                "dateOfAssessment": "2011-01-01",
                "typeOfAssessment": "RdSAP",
                "assessmentId": "0000-0000-0000-0000-0001",
                "currentEnergyEfficiencyRating": 67,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2021-01-01",
                "addressId": "UPRN-000000000000",
                "addressLine1": "A1-L1",
                "addressLine2": "A1-L2",
                "addressLine3": "A1-L3",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2011-02-01",
                "typeOfAssessment": "RdSAP",
                "assessmentId": "0000-0000-0000-0000-0002",
                "currentEnergyEfficiencyRating": 68,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2021-02-01",
                "addressId": "UPRN-000000000000",
                "addressLine1": "A2-L1",
                "addressLine2": "A2-L2",
                "addressLine3": "A2-L3",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2011-04-01",
                "typeOfAssessment": "RdSAP",
                "assessmentId": "0000-0000-0000-0000-0003",
                "currentEnergyEfficiencyRating": 55,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2021-03-01",
                "addressId": "UPRN-000000000000",
                "addressLine1": "A3-L1",
                "addressLine2": "A3-L2",
                "addressLine3": "A3-L3",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2011-03-01",
                "typeOfAssessment": "SAP",
                "assessmentId": "0000-0000-0000-0000-0004",
                "currentEnergyEfficiencyRating": 60,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2021-04-01",
                "addressId": "UPRN-000000000000",
                "addressLine1": "A4-L1",
                "addressLine2": "A4-L2",
                "addressLine3": "A4-L3",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2011-03-01",
                "typeOfAssessment": "SAP",
                "assessmentId": "0000-0000-0000-0000-0005",
                "currentEnergyEfficiencyRating": 60,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2021-04-01",
                "addressId": "UPRN-000000000000",
                "addressLine1": "A5-L1",
                "addressLine2": "A5-L2",
                "addressLine3": "A5-L3",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            }
        ]
    },
    "meta": {
        "searchQuery": "SW1W 8ED"
    }
}'
  end

  def get_non_domestic_search_by_postcode
    '{
    "data": {
        "assessments": [
            {
                "dateOfAssessment": "2020-06-12",
                "typeOfAssessment": "CEPC",
                "assessmentId": "0560-0630-5012-9408-6007",
                "currentEnergyEfficiencyRating": 40,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2030-08-08",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Limited",
                "addressLine2": "350 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "e",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2020-06-12",
                "typeOfAssessment": "CEPC-RR",
                "assessmentId": "0080-6206-0410-5540-6666",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2030-08-08",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Limited",
                "addressLine2": "350 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2017-09-04",
                "typeOfAssessment": "CEPC",
                "assessmentId": "9659-3041-0031-0600-4444",
                "currentEnergyEfficiencyRating": 80,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2027-09-06",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Inc",
                "addressLine2": "350 High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "c",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2017-09-04",
                "typeOfAssessment": "CEPC-RR",
                "assessmentId": "0460-0643-5019-9401-6666",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2027-09-06",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Inc",
                "addressLine2": "350 High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2018-01-22",
                "typeOfAssessment": "DEC",
                "assessmentId": "0290-4950-0358-9240-4444",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2028-02-18",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Ltd",
                "addressLine2": "350, The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "f",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2018-01-22",
                "typeOfAssessment": "DEC-RR",
                "assessmentId": "9496-4049-0585-0400-2222",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2028-02-18",
                "addressId": "UPRN-123456789012",
                "addressLine1": "Supershop Ltd",
                "addressLine2": "350, The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2019-01-22",
                "typeOfAssessment": "DEC",
                "assessmentId": "9000-3952-0385-3610-7777",
                "currentEnergyEfficiencyRating": 130,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2025-10-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Supershop",
                "addressLine2": "350-352 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "a",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2019-06-12",
                "typeOfAssessment": "AC-CERT",
                "assessmentId": "9856-6086-0413-0600-2222",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2024-06-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Cool Supershop",
                "addressLine2": "350-352 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2019-06-12",
                "typeOfAssessment": "AC-REPORT",
                "assessmentId": "0960-8949-0531-5280-6666",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2024-06-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Cool Supershop",
                "addressLine2": "350-352 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2020-08-05",
                "typeOfAssessment": "AC-CERT",
                "assessmentId": "9856-6086-0413-0600-3333",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2024-06-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Coolest Supershop",
                "addressLine2": "350-354 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2020-08-05",
                "typeOfAssessment": "AC-REPORT",
                "assessmentId": "0960-8949-0531-5280-7777",
                "currentEnergyEfficiencyRating": 0,
                "optOut": false,
                "postcode": "SW1W 8ED",
                "dateOfExpiry": "2024-06-11",
                "addressId": "UPRN-123456789012",
                "addressLine1": "The Coolest Supershop",
                "addressLine2": "350-354 The High Road",
                "addressLine3": "",
                "addressLine4": "",
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "g",
                "status": "ENTERED"
            }
        ]
    },
    "meta": {
        "searchQuery": "SW1W 8ED"
    }
}'
  end
end
