require "rspec"
require "json"

describe UseCase::FilterLatestCertificates do
  let(:usecase) { described_class.new(nil) }

  context "when processing a response from domestic assessment search by postcode" do
    let(:latest_registered_sap) do
      json_body =
        '{
            "dateOfAssessment": "2011-03-01",
            "dateOfRegistration": "2011-04-14",
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
          }'
      JSON.parse(json_body, symbolize_names: true)
    end

    let(:get_domestic_search_by_postcode_response) do
      response = '{
        "data": {
          "assessments": [
              {
                  "dateOfAssessment": "2011-01-01",
                  "dateOfRegistration": "2011-01-03",
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
                  "dateOfRegistration": "2011-02-06",
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
                  "dateOfRegistration": "2011-04-03",
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
                  "dateOfRegistration": "2011-04-14",
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
                  "dateOfRegistration": "2011-04-13",
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
            "meta": { "searchQuery": "SW1W 8ED" }
        }'
      JSON.parse(response, symbolize_names: true)
    end

    let(:json_response) do
      JSON.parse(get_domestic_search_by_postcode, symbolize_names: true)
    end

    let(:result) { usecase.execute(get_domestic_search_by_postcode_response) }

    it "returns the address with the most recent certificate of any domestic type" do
      certificates = result[:"UPRN-000000000000"][:certificates]
      expect(certificates).to contain_exactly(latest_registered_sap)
    end

    it "returns the address with the most recent address lines" do
      address = result[:"UPRN-000000000000"]
      expect([address[:addressLine1], address[:addressLine2], address[:addressLine3]]).to eq %w[A4-L1 A4-L2 A4-L3]
    end
  end

  context "when two certificates for the same property were lodged on the same day" do
    let(:response) do
      response = '{
        "data": {
          "assessments": [
              {
                  "dateOfAssessment": "2011-01-01",
                  "dateOfRegistration": "2011-01-01",
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
                  "currentEnergyEfficiencyBand": "f",
                  "status": "ENTERED",
                  "createdAt": "2011-01-01T12:00:00.789Z"
              },
              {
                  "dateOfAssessment": "2011-01-01",
                  "dateOfRegistration": "2011-01-01",
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
                  "status": "ENTERED",
                  "createdAt": "2011-01-01T15:00:00.789Z"
                }
              ]
            },
            "meta": { "searchQuery": "SW1W 8ED" }
        }'
      JSON.parse(response, symbolize_names: true)
    end

    let(:latest_registered_rdsap) do
      json_body = '{
      "dateOfAssessment": "2011-01-01",
      "dateOfRegistration": "2011-01-01",
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
      "status": "ENTERED",
      "createdAt": "2011-01-01T15:00:00.789Z"
        }'
      JSON.parse(json_body, symbolize_names: true)
    end

    it "returns the certificate with more recent createdAt" do
      certificates = usecase.execute(response)[:"UPRN-000000000000"][:certificates]

      expect(certificates).to contain_exactly(latest_registered_rdsap)
    end

    context "when createdAt is null and the dates of assessment match" do
      let(:response) do
        response = '{
          "data": {
            "assessments": [
                {
                    "dateOfAssessment": "2011-01-01",
                    "dateOfRegistration": "2011-01-01",
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
                    "currentEnergyEfficiencyBand": "f",
                    "status": "ENTERED",
                    "createdAt": null
                },
                {
                    "dateOfAssessment": "2011-01-01",
                    "dateOfRegistration": "2011-01-01",
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
                    "status": "ENTERED",
                    "createdAt": null
                  }
                ]
              },
              "meta": { "searchQuery": "SW1W 8ED" }
          }'
        JSON.parse(response, symbolize_names: true)
      end

      it "returns the first certificate in the response" do
        certificates = usecase.execute(response)[:"UPRN-000000000000"][:certificates]

        expect(certificates.first[:assessmentId]).to eq("0000-0000-0000-0000-0001")
      end
    end

    context "when createdAt is null and the dates of assessment do not match" do
      let(:response) do
        response = '{
          "data": {
            "assessments": [
                {
                    "dateOfAssessment": "2010-12-30",
                    "dateOfRegistration": "2011-01-01",
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
                    "currentEnergyEfficiencyBand": "f",
                    "status": "ENTERED",
                    "createdAt": null
                },
                {
                    "dateOfAssessment": "2011-01-01",
                    "dateOfRegistration": "2011-01-01",
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
                    "status": "ENTERED",
                    "createdAt": null
                  }
                ]
              },
              "meta": { "searchQuery": "SW1W 8ED" }
          }'
        JSON.parse(response, symbolize_names: true)
      end

      it "returns the certificate with the most recent date of assessment in the response" do
        certificates = usecase.execute(response)[:"UPRN-000000000000"][:certificates]

        expect(certificates.first[:assessmentId]).to eq("0000-0000-0000-0000-0002")
      end
    end
  end

  context "when processing a response from non-domestic assessment search by postcode" do
    let(:latest_registered_cepc) do
      json_body =
        '{
                  "dateOfAssessment": "2020-06-12",
                  "dateOfRegistration": "2020-08-11",
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

    let(:latest_registered_cepc_rr) do
      json_body =
        '{
                  "dateOfAssessment": "2020-06-12",
                  "dateOfRegistration": "2020-08-11",
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

    let(:latest_registered_dec) do
      json_body =
        '{
                  "dateOfAssessment": "2018-01-22",
                  "dateOfRegistration": "2023-02-20",
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
              }'
      JSON.parse(json_body, symbolize_names: true)
    end

    let(:latest_registered_dec_rr) do
      json_body =
        '{
                  "dateOfAssessment": "2018-01-22",
                  "dateOfRegistration": "2018-02-14",
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

    let(:latest_registered_ac_cert) do
      json_body =
        '{
                  "dateOfAssessment": "2020-08-05",
                  "dateOfRegistration": "2020-08-07",
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

    let(:latest_registered_ac_report) do
      json_body =
        '{
                  "dateOfAssessment": "2020-08-05",
                  "dateOfRegistration": "2020-08-11",
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

    let(:get_non_domestic_search_by_postcode) do
      '{
      "data": {
          "assessments": [
              {
                  "dateOfAssessment": "2020-06-12",
                  "dateOfRegistration": "2020-08-11",
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
                  "dateOfRegistration": "2020-08-11",
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
                  "dateOfRegistration": "2017-09-09",
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
                  "dateOfRegistration": "2017-09-08",
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
                  "dateOfRegistration": "2023-02-20",
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
                  "dateOfRegistration": "2018-02-14",
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
                  "dateOfRegistration": "2020-10-11",
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
                  "dateOfRegistration": "2019-06-13",
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
                  "dateOfRegistration": "2019-06-13",
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
                  "dateOfRegistration": "2020-08-07",
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
                  "dateOfRegistration": "2020-08-11",
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

    let(:json_response) { JSON.parse(get_non_domestic_search_by_postcode, symbolize_names: true) }

    let(:result) { usecase.execute(json_response) }

    it "returns the address with the most recent certificate for each type" do
      certificates = result[:"UPRN-123456789012"][:certificates]
      expect(certificates).to contain_exactly(
        latest_registered_cepc,
        latest_registered_cepc_rr,
        latest_registered_dec,
        latest_registered_dec_rr,
        latest_registered_ac_cert,
        latest_registered_ac_report,
      )
    end

    it "returns the address with the most recent address lines" do
      address = result[:"UPRN-123456789012"]
      expect([address[:addressLine1], address[:addressLine2]]).to eq ["Supershop Ltd", "350, The High Road"]
    end
  end
end
