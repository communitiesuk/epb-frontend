# frozen_string_literal: true

require "net/http"
require "zeitwerk"
require "webmock"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.push_dir("#{__dir__}/spec/test_doubles/")
loader.setup

WebMock.enable!

OauthStub.token
FindAssessor::ByPostcode::Stub.search_by_postcode(
  "SW1A 2AA",
  "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
)
FindAssessor::ByPostcode::Stub.search_by_postcode("SW1A 2AA")
FindAssessor::ByPostcode::InvalidPostcodeStub.search_by_postcode("C11 4FF")
FindAssessor::ByName::Stub.search_by_name("Supercommon Name")
FindAssessor::ByName::Stub.search_by_name("Somewhatcommon Name", true)
FindCertificate::NoCertificatesStub.search_by_postcode("E1 4FF")
FindCertificate::Stub.search_by_postcode("SW1A 2AA")
FindCertificate::Stub.search_by_postcode("SW1A 2AA", "CEPC")
FindCertificate::Stub.search_by_id("4567-6789-4567-6789-4567")
FindCertificate::Stub.search_by_id("1234-5678-1234-5678-1234", "CEPC")
FindCertificate::Stub.search_by_id("1234-5678-1234-5678-0000", "CEPC-RR")
FindCertificate::Stub.search_by_id("0000-0000-0000-0000-1111", "DEC")
FindCertificate::Stub.search_by_id("1204-5678-1234-5178-0000", "DEC-RR")
FindCertificate::Stub.search_by_id("0000-0000-0000-0000-9999", "AC-CERT")
FindCertificate::Stub.search_by_id("0000-0000-0000-0000-5555", "AC-REPORT")
FindCertificate::Stub.search_by_street_name_and_town(
  "1 Makeup Street",
  "Beauty Town",
)
FindCertificate::Stub.search_by_street_name_and_town(
  "1 Commercial Street",
  "Industry Town",
  %w[DEC DEC-RR CEPC CEPC-RR AC-REPORT AC-CERT],
  "CEPC",
)

FindCertificate::NoCertificatesStub.search_by_street_name_and_town(
  "Madeup Street",
  "Madeup Town",
)
FetchAssessmentSummary::AssessmentStub.fetch_rdsap("4567-6789-4567-6789-4567")
FetchAssessmentSummary::AssessmentStub.fetch_rdsap("0000-0000-0000-0000-0001")

FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
  "1234-5678-9101-1122-1234",
  "25",
  "f",
  true,
  "7.8254",
  "6.5123",
  nil,
  nil,
  nil,
  nil,
  1,
  [
    { name: "walls", description: "Its a wall", energyEfficiencyRating: 2 },
    {
      name: "secondary_heating",
      description: "Heating the house",
      energyEfficiencyRating: 5,
    },
    {
      name: "main_heating",
      description: "Room heaters, electric",
      energyEfficiencyRating: 3,
    },
    {
      name: "roof",
      description: "(another dwelling above)",
      energyEfficiencyRating: 0,
    },
  ],
)

FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                    "1234-5678-1234-5678-1234",
                                                  energyEfficiencyBand: "b",
                                                  related_rrn:
                                                    "1234-5678-1234-5678-0000"

FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr assessment_id:
                                                       "1234-5678-1234-5678-0000"

FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                    "1111-0000-0000-0000-0000",
                                                  energyEfficiencyBand: "b",
                                                  related_rrn:
                                                    "1111-0000-0000-0000-0001"

FetchAssessmentSummary::AssessmentStub.fetch_dec assessment_id:
                                                   "0000-0000-0000-0000-1111",
                                                 date_of_expiry: "2030-01-28"

FetchAssessmentSummary::AssessmentStub.fetch_dec_rr assessment_id:
                                                      "1204-5678-1234-5178-0000"

FetchAssessmentSummary::AssessmentStub.fetch_ac_cert assessment_id:
                                                       "0000-0000-0000-0000-9999"

FetchAssessmentSummary::AssessmentStub.fetch_ac_report assessment_id:
                                                         "0000-0000-0000-0000-5555"
FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
  assessment_id: "0000-0000-0000-0000-5556",
  cooling_plants: [],
  air_handling_systems: [],
  terminal_units: [],
  system_controls: [],
  pre_inspection_checklist: {
    pcs: {
      essential: {
        listOfSystems: false,
        temperatureControlMethod: false,
        operationControlMethod: false,
      },
      desirable: {
        previousReports: false,
        maintenanceRecords: false,
        calibrationRecords: false,
        consumptionRecords: false,
      },
      optional: {
        coolingLoadEstimate: false,
        complaintRecords: false,
      },
    },
    sccs: {
      essential: {
        listOfSystems: true,
        coolingCapacities: true,
        controlZones: true,
        temperatureControls: true,
        operationControls: true,
        schematics: false,
      },
      desirable: {
        previousReports: true,
        refrigerationMaintenance: false,
        deliverySystemMaintenance: true,
        controlSystemMaintenance: true,
        consumptionRecords: true,
        commissioningResults: true,
      },
      optional: {
        coolingLoadEstimate: true,
        complaintRecords: true,
        bmsCapability: true,
        monitoringCapability: true,
      },
    },
  },
)

ENV["EPB_AUTH_CLIENT_ID"] = "test.id"
ENV["EPB_AUTH_CLIENT_SECRET"] = "test.client.secret"
ENV["EPB_AUTH_SERVER"] = "http://test-auth-server.gov.uk"
ENV["EPB_API_URL"] = "http://test-api.gov.uk"

run FrontendService.new
