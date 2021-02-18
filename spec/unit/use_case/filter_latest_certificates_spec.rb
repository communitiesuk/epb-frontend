require "rspec"
require "json"

describe "UseCase::FilterLatestCertificates" do
  before do
    @usecase = UseCase::FilterLatestCertificates.new(nil)
  end

  context "When processing a response from assessment search by postcode" do
    let(:json_response) { JSON.parse(get_search_by_postcode, symbolize_names: true) }
    let(:result) { @usecase.execute(json_response) }

    it "Then the resulting address contains the most recent certificates for each type" do
      certificates = result[:"UPRN-000000000000"][:certificates]
      expect(certificates).to contain_exactly(latest_sap_certificate, latest_rdsap_certificate)
    end

    it "Then the resulting address has the most recent address lines" do
      address = result[:"UPRN-000000000000"]
      expect(address[:addressLine1]).to eq "A4-L1"
      expect(address[:addressLine2]).to eq "A4-L2"
      expect(address[:addressLine3]).to eq "A4-L3"
      expect(address[:addressLine4]).to be_nil
      expect(address[:town]).to eq "LONDON"
      expect(address[:postcode]).to eq "SW1W 8ED"
    end
  end
end

private

def latest_sap_certificate
  json_body = '{
    "dateOfAssessment": "2011-04-01",
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
    "addressLine4": null,
    "town": "LONDON",
    "currentEnergyEfficiencyBand": "d",
    "status": "ENTERED"
  }'
  JSON.parse(json_body, symbolize_names: true)
end

def latest_rdsap_certificate
  json_body = '{
    "dateOfAssessment": "2011-03-01",
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
    "addressLine4": null,
    "town": "LONDON",
    "currentEnergyEfficiencyBand": "d",
    "status": "ENTERED"
  }'
  JSON.parse(json_body, symbolize_names: true)
end

def get_search_by_postcode
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
                "addressLine4": null,
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
                "addressLine4": null,
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2011-03-01",
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
                "addressLine4": null,
                "town": "LONDON",
                "currentEnergyEfficiencyBand": "d",
                "status": "ENTERED"
            },
            {
                "dateOfAssessment": "2011-04-01",
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
                "addressLine4": null,
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
                "addressLine4": null,
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
