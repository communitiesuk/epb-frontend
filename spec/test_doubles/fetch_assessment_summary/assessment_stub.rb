# frozen_string_literal: true

module FetchAssessmentSummary
  class AssessmentStub
    def self.fetch_ac_report(
      assessment_id:,
      executive_summary: "My\nSummary\t\tInspected",
      sub_systems: [
        volumeDefinitions: "VOL001 The Shop",
        id: "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
        description:
          "This sub system comprised of; 4Nr 10kW R410A Mitsubishi Heavy Industries inverter driven split AC condensers.",
        coolingOutput: "40",
        areaServed: "Sales Area",
        inspectionDate: "2019-05-20",
        coolingPlantCount: "4",
        ahuCount: "0",
        terminalUnitsCount: "4",
        controlsCount: "5",
      ]
    )
      body = {
        data: {
          typeOfAssessment: "AC-REPORT",
          assessmentId: assessment_id,
          reportType: "5",
          dateOfExpiry: "2025-02-06",
          address: {
            addressLine1: "",
            addressLine2: "The Bank Plc",
            addressLine3: "49-51 Northumberland Street",
            addressLine4: "",
            town: "NEWCASTLE UPON TYNE",
            postcode: "NE1 7AF",
          },
          relatedPartyDisclosure: "1",
          relatedRrn: "0000-0000-0000-0003",
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            contactDetails: {
              email: "test@testscheme.com", telephone: "012345"
            },
            companyDetails: {
              name: "Joe Bloggs Ltd", address: "123 My Street, My City, AB3 4CD"
            },
            registeredBy: { name: "quidos", schemeId: "3" },
          },
          executiveSummary: executive_summary,
          equipmentOwner: {
            name: "Office manager",
            telephone: "01234",
            organisation: "The bank",
            address: {
              addressLine1: "High street",
              addressLine2: "North side",
              addressLine3: nil,
              addressLine4: nil,
              town: "NEWCASTLE UPON TYNE",
              postcode: "NE2 7DT",
            },
          },
          equipmentOperator: {
            responsiblePerson: "Chief engineer",
            telephone: "44432",
            organisation: "Air Con Ltd",
            address: {
              addressLine1: "Low street",
              addressLine2: nil,
              addressLine3: nil,
              addressLine4: nil,
              town: "COVENTRY",
              postcode: "CV11 2FF",
            },
          },
          keyRecommendations: {
            efficiency: [
              { sequence: "0", text: "A way to improve your efficiency" },
              { sequence: "1", text: "A second way to improve efficiency" },
            ],
            maintenance: [{ sequence: "0", text: "Text2" }],
            control: [{ sequence: "0", text: "Text4" }],
            management: [{ sequence: "0", text: "Text6" }],
          },
          subSystems: sub_systems,
          preInspectionChecklist: {
            essential: {
              controlZones: false,
              coolingCapacities: false,
              listOfSystems: true,
              operationControls: false,
              schematics: false,
              temperatureControls: false,
            },
            desirable: {
              commissioningResults: false,
              consumptionRecords: false,
              controlSystemMaintenance: false,
              deliverySystemMaintenance: false,
              previousReports: false,
              refrigerationMaintenance: false,
            },
            optional: {
              bmsCapability: false,
              complaintRecords: false,
              coolingLoadEstimate: false,
              monitoringCapability: false,
            },
          },
          coolingPlants: [
            {
              systemNumber:
                "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
              identifier:
                "VOL001/SYS001/CP1 Sampled R410A Inverter Split Area (1)",
              equipment: {
                coolingCapacity: "10",
                description: "Single Split",
                location: "Externally on roof",
                manufacturer: "Mitsubishi",
                modelReference: "FDC100VN",
                refrigerantCharge: "3",
                refrigerantType: {
                  ecfgasregulation: nil, ecozoneregulation: nil, type: "R410A"
                },
                serialNumber: "not visible",
                yearInstalled: "2014",
                discrepancyNote: "Something more random",
              },
              inspection: {
                airRecirculation: {
                  note: "The condenser was considered suitably located.",
                  state: true,
                },
                chillerPlacementOk: {
                  note: "The condenser is considered suitably located.",
                  state: true,
                },
                chillerPlantAreaClear: {
                  note: "Area appeared clear and satisfactory.", state: true
                },
                chillerPlantOk: {
                  note: "General condition of the plant appeared satisfactory.",
                  state: true,
                },
                chillerPlantOperational: {
                  note: "System appeared to operate satisfactorily.",
                  state: true,
                },
                compressorsOperational: {
                  note:
                    "The compressor appeared to operate satisfactorily with the air off temperatures as expected.",
                  state: true,
                },
                heatExchangerOk: {
                  note: "Heat exchangers appeared satisfactory and clean.",
                  state: true,
                },
                heatRejectionAreaClear: {
                  note: "The area was clear and appeared satisfactory.",
                  state: true,
                },
                heatRejectionOperational: {
                  note: "Heat rejection plant appeared to operate as expected.",
                  state: true,
                },
                pipeInsulationOk: {
                  note:
                    "Thermal insulation appeared in good order and well fitted.",
                  state: true,
                },
              },
              sizing: {
                acceptableInstalledSize: "1",
                guidance: [
                  {
                    code: "OTHER",
                    seqNumber: "1",
                    text:
                      "This occupancy is based on information obtained from site",
                  },
                  {
                    code: "OTHER",
                    seqNumber: "2",
                    text:
                      "No recommendation required; occupancy level appears appropriate.",
                  },
                  {
                    code: "OTHER",
                    seqNumber: "3",
                    text: "Floor area was measured whilst on site.",
                  },
                  {
                    code: "OTHER",
                    seqNumber: "4",
                    text: "No recommendation required.",
                  },
                ],
                installedCapacity: "10.0",
                occupantDensity: "8.93",
                totalFloorArea: "357",
                totalOccupants: "40",
                upperHeatGain: "140.0",
              },
              refrigeration: {
                acceptableTemperature: "0",
                ambient: "13",
                compressorControl: {
                  note: "The capacity control is inverter.",
                },
                fGasInspection: {
                  note:
                    "The system operated using refrigerant which is not banned.",
                  state: true,
                },
                guidance: [
                  {
                    code: "OTHER",
                    seqNumber: "1",
                    text:
                      "Access to the pre and post compressor for this type of system is difficult with a visual inspection; therefore the air on/room temperature and air off temperatures were taken from the indoor unit. (Pre Compressor temperature detailed is therefore the room temperature).",
                  },
                  {
                    code: "OTHER",
                    seqNumber: "2",
                    text: "No recommendation required.",
                  },
                ],
                postProcessor: "7",
                preCompressor: "22",
                refrigerantLeak: {
                  note:
                    "There were no visible signs of a leak observed during the inspection.",
                  state: false,
                },
                refrigerantName: "R410A",
              },
              maintenance: {
                competentPerson: {
                  note:
                    "Maintenance contract advised as being in place and would appear satisfactory due to unit condition.",
                  state: true,
                },
                guidance: nil,
                recordsKept: {
                  note: "Yes system appears in good order for age.", state: true
                },
              },
              metering: {
                bemInstalled: {
                  note: "The system is linked to a Central Controller.",
                  state: true,
                },
                excessiveUse: { note: "No details available.", state: false },
                meteringInstalled: { note: "987654321", state: true },
                usageRecords: {
                  note:
                    "There were no records of air conditioning plant usage or sub-metered energy consumption with expected hours of use per year for the plant or systems located on site.",
                  state: false,
                },
              },
              humidityControl: {
                note: "N/A no humidity control installed to this system",
                state: false,
              },
            },
            {
              systemNumber:
                "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
              identifier:
                "VOL001/SYS001/CP2 Sampled R410A Inverter Split Area (2)",
              equipment: {
                coolingCapacity: "10",
                description: "Single Split",
                location: "Externally on roof",
                manufacturer: "Mitsubishi",
                modelReference: "FDC100VN",
                refrigerantCharge: "3",
                refrigerantType: {
                  ecfgasregulation: nil, ecozoneregulation: nil, type: "R410A"
                },
                serialNumber: "not visible",
                yearInstalled: "2014",
                areaServed: "Sales Area",
                discrepancyNote: "Something random",
              },
              inspection: {},
              sizing: {
                acceptableInstalledSize: "1",
                guidance: [
                  {
                    code: "OTHER",
                    seqNumber: "1",
                    text:
                      "This occupancy is based on information obtained from site",
                  },
                  {
                    code: "OTHER",
                    seqNumber: "2",
                    text:
                      "No recommendation required; occupancy level appears appropriate.",
                  },
                ],
                installedCapacity: "10.0",
                occupantDensity: "8.93",
                totalFloorArea: "357",
                totalOccupants: "40",
                upperHeatGain: "140.0",
              },
              refrigeration: {
                acceptableTemperature: "0",
                ambient: "13",
                compressorControl: {
                  note: "The capacity control is inverter.",
                },
                fGasInspection: {
                  note:
                    "The system operated using refrigerant which is not banned.",
                  state: true,
                },
                guidance: [
                  {
                    code: "OTHER",
                    seqNumber: "1",
                    text:
                      "Access to the pre and post compressor for this type of system is difficult with a visual inspection.",
                  },
                  {
                    code: "OTHER",
                    seqNumber: "2",
                    text: "No recommendation required.",
                  },
                ],
                postProcessor: "8",
                preCompressor: "22",
                refrigerantLeak: {
                  note:
                    "There were no visible signs of a leak observed during the inspection.",
                  state: false,
                },
                refrigerantName: "R410A",
              },
              maintenance: {
                competentPerson: {
                  note:
                    "Maintenance contract advised as being in place and would appear satisfactory due to unit condition.",
                  state: true,
                },
                guidance: nil,
                recordsKept: {
                  note: "Yes system appears in good order for age.", state: true
                },
              },
              metering: {
                bemInstalled: {
                  note: "The system is linked to a Central Controller.",
                  state: true,
                },
                excessiveUse: { note: "No details available.", state: false },
                meteringInstalled: { note: "", state: false },
                usageRecords: {
                  note:
                    "There were no records of air conditioning plant usage or sub-metered energy consumption with expected hours of use per year for the plant or systems located on site.",
                  state: false,
                },
              },
              humidityControl: {
                note: "N/A no humidity control installed to this system",
                state: false,
              },
            },
          ],
          airHandlingSystems: [
            {
              equipment: {
                areasServed: "Corridor",
                component: "VENT1 Heat recovery",
                discrepancy: "None",
                location: "Above corridor ceiling",
                manufacturer: "NUAIRE",
                systemsServed: "Corridor",
                unit: "123",
                yearInstalled: "2016",
              },
              inspection: {
                filters: {
                  filterCondition: {
                    flag: true, note: nil, recommendations: []
                  },
                  changeFrequency: {
                    flag: true,
                    note:
                      "Originally changed on an annual basis but now upgraded to six monthly.",
                    recommendations: [
                      { sequence: "0", text: "Change this more frequently" },
                    ],
                  },
                  differentialPressureGauge: {
                    flag: false, note: "Not fitted.", recommendations: []
                  },
                },
                heatExchangers: {
                  condition: { flag: true, note: nil, recommendations: [] },
                },
                refrigeration: {
                  leaks: { flag: true, note: nil, recommendations: [] },
                },
                fanRotation: {
                  direction: { flag: true, note: nil, recommendations: [] },
                  modulation: { flag: true, note: nil, recommendations: [] },
                },
                airLeakage: {
                  condition: { note: "No leaks", recommendations: [] },
                },
                heatRecovery: {
                  energyConservation: { note: "None", recommendations: [] },
                },
                outdoorInlets: {
                  condition: { note: "Diffusers clean", recommendations: [] },
                },
                fanControl: {
                  setting: { note: "No dampers", recommendations: [] },
                },
                fanPower: {
                  condition: { note: nil, flag: true, recommendations: [] },
                  sfpCalculation: "464 watts x 70% - 0.311/400 = 8.12 w/ltr.",
                },
              },
            },
          ],
          terminalUnits: [
            {
              equipment: {
                unit: "VOL1/SYS1",
                component:
                  "Indoor wall type split which is part of a multi system with 5 indoor units.",
                description: "VOL1/SYS1/a",
                coolingPlant: "Cooling system",
                manufacturer: "Mitsubishi Electric",
                yearInstalled: "2011",
                areaServed: "ICT Suite",
                discrepancy: "None",
              },
              inspection: {
                insulation: {
                  pipework: { note: nil, recommendations: [], flag: true },
                  ductwork: { note: nil, recommendations: [], flag: false },
                },
                unit: {
                  condition: { note: nil, recommendations: [], flag: true },
                },
                grillesAirFlow: {
                  distribution: { note: nil, recommendations: [], flag: true },
                  tampering: { note: nil, recommendations: [], flag: true },
                  waterSupply: { note: nil, recommendations: [], flag: false },
                  complaints: { note: nil, recommendations: [], flag: false },
                },
                diffuserPositions: {
                  positionIssues: {
                    note: nil, recommendations: [], flag: true
                  },
                  partitioningIssues: {
                    note: nil, recommendations: [], flag: false
                  },
                  controlOperation: {
                    note: nil, recommendations: [], flag: true
                  },
                },
              },
            },
          ],
          systemControls: [
            {
              subSystemId:
                "VOL001/SYS001 R410A Inverter Split Systems to Sales Area",
              component:
                "VOL001/SYS001/SC1 AC Local Controller to Sales Area Unit 1",
              inspection: {
                zoning: {
                  note:
                    "Local Controller\n\n            Zoning is considered satisfactory as systems are linked to single controller.",
                  recommendations: [
                    {
                      sequence: "1",
                      text:
                        "Where an area/room has more than one AC system installed that have separate controllers; it should be ensured that AC systems are set to the same set point temperature and mode (heating/cooling/auto).",
                    },
                  ],
                  flag: true,
                },
                time: {
                  note:
                    "Time/date on the local controller is not used as Central controller timeclock controls the units.",
                  recommendations: [
                    { sequence: "1", text: "No recommendation required." },
                  ],
                },
                setOnPeriod: {
                  note: "N/A Central controller timeclock controls the units.",
                  recommendations: [
                    { sequence: "1", text: "No recommendation required" },
                  ],
                },
                timerShortfall: {
                  note: "There is no shortfall in controller capabilities.",
                  recommendations: [
                    { sequence: "1", text: "No recommendation required." },
                  ],
                  flag: false,
                },
                sensors: {
                  note: "Sensors are considered satisfactory.",
                  recommendations: [
                    { sequence: "1", text: "No recommendation required." },
                  ],
                  flag: true,
                },
                setTemperature: {
                  note: "The set temperature on local controller; 18 deg C",
                  recommendations: [
                    {
                      sequence: "1",
                      text:
                        "Ensure staff are educated to run AC systems for comfort and efficiency by setting the AC system temperature to circa 22 deg C +/- 1 deg C.",
                    },
                  ],
                },
                deadBand: {
                  note:
                    "System dead-bands for the indoor unit are set at manufacture stage, these are considered satisfactory.",
                  recommendations: [
                    {
                      sequence: "1",
                      text:
                        "There were LPHW ceiling heaters within the same zones as AC systems and it was unclear from the BMS panel whether interlocks were provided between the systems to prevent both operating simultaneously. This should be investigated at head office were the BMS is set from and ensure that the AC systems do not operate at the same time as the heating and that adequate dead-bands are configured between the systems.",
                    },
                  ],
                },
                capacity: {
                  note: "",
                  recommendations: [
                    { sequence: "1", text: "No recommendation required." },
                  ],
                  flag: true,
                },
                airflow: {
                  note: "N/A Unit is not ducted type",
                  recommendations: [
                    {
                      sequence: "1",
                      text:
                        "Considered satisfactory, no recommendation required.",
                    },
                  ],
                },
                guidanceControls: {
                  note: "Provision of Guidance notices would be useful.",
                  recommendations: [
                    {
                      sequence: "1",
                      text:
                        "Consider providing ‘Good Practise Guideline’ notices (laminated sheet adjacent each AC controller) including ‘simple step’ recommendations on how to operate the systems efficiently.",
                    },
                  ],
                  flag: false,
                },
              },
            },
          ],
        },
        meta: {},
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_ac_cert(
      assessment_id:,
      f_gas_compliant_date: "20/09/2010",
      system_sampling: "Y",
      subsystems_metered: "1",
      related_party_disclosure: "1"
    )
      body = {
        data: {
          assessmentId: assessment_id,
          reportType: "3",
          typeOfAssessment: "AC-CERT",
          dateOfExpiry: "2024-09-21",
          address: {
            addressLine1: "66 Primrose Hill",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "London",
            postcode: "SW1B 2BB",
          },
          technicalInformation: {
            dateOfAssessment: "2019-09-22",
            buildingComplexity: "Level 3",
            calculationTool: "CLG, ACReport, v2.0",
            fGasCompliantDate: f_gas_compliant_date,
            acRatedOutput: "106",
            randomSampling: system_sampling,
            treatedFloorArea: "410",
            acSystemMetered: subsystems_metered,
            refrigerantCharge: "73",
          },
          relatedPartyDisclosure: related_party_disclosure,
          relatedRrn: "0000-0000-0000-0000-8888",
          subsystems: [
            {
              number:
                "VOL001/SYS001/CP001 Ground Floor Banking Hall, Interview Room and Cashiers Area",
              description:
                "Mitsubishi Electric PURY-P250LM-A1 VRF packaged system x 1 serve ceiling slot diffuser internal unit x 6",
              age: "2013",
              refrigerantType: "R410A",
            },
            {
              number:
                "VOL001/SYS002/ CP002 Lower Ground Floor Waiting Area and Interview Room Areas",
              description:
                "Mitsubishi Electric PURY-P450LM-A1 VRF packaged system x 1 serve ceiling slot diffuser internal unit x 10",
              age: "2017",
              refrigerantType: "R410A",
            },
          ],
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            contactDetails: {
              email: "test@testscheme.com", telephone: "012345"
            },
            companyDetails: {
              name: "Joe Bloggs Ltd", address: "123 My Street, My City, AB3 4CD"
            },
            registeredBy: { name: "quidos", schemeId: "3" },
          },
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_cepc(
      assessment_id:,
      energyEfficiencyBand:,
      related_rrn: "4192-1535-8427-8844-6702",
      related_party_disclosure: nil,
      related_assessments: [
        {
          assessmentExpiryDate: "2026-05-04",
          assessmentId: "0000-0000-0000-0000-0001",
          assessmentStatus: "ENTERED",
          assessmentType: "CEPC",
        },
        {
          assessmentExpiryDate: "2002-07-01",
          assessmentId: "0000-0000-0000-0000-0002",
          assessmentStatus: "EXPIRED",
          assessmentType: "CEPC-RR",
        },
      ]
    )
      body = {
        data: {
          assessmentId: assessment_id,
          dateOfExpiry: "2030-01-05",
          dateOfAssessment: "2020-01-04",
          dateOfRegistration: "2020-01-05",
          reportType: "3",
          typeOfAssessment: "CEPC",
          address: {
            addressLine1: "Flat 33",
            addressLine2: "2 Marsham Street",
            addressLine3: nil,
            addressLine4: nil,
            town: "London",
            postcode: "SW1B 2BB",
          },
          technicalInformation: {
            mainHeatingFuel: "Natural Gas",
            buildingEnvironment: "Air Conditioning",
            floorArea: "403",
            buildingLevel: "3",
          },
          buildingEmissionRate: "67.09",
          primaryEnergyUse: "413.22",
          relatedRrn: related_rrn,
          newBuildRating: "28",
          newBuildBand: "b",
          existingBuildRating: "81",
          existingBuildBand: "d",
          energyEfficiencyRating: "35",
          currentEnergyEfficiencyBand: energyEfficiencyBand,
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            contactDetails: {
              email: "test@testscheme.com", telephone: "012345"
            },
            companyDetails: {
              name: "Joe Bloggs Ltd",
              address: "Lloyds House, 18 Lloyd Street, Manchester, M2 5WA",
            },
            registeredBy: { name: "quidos", schemeId: "3" },
          },
          relatedPartyDisclosure: related_party_disclosure,
          propertyType: "B1 Offices and Workshop businesses",
          relatedAssessments: related_assessments,
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_cepc_rr(
      assessment_id: "0000-0000-0000-0000-0001",
      date_of_expiry: "2030-01-01",
      linked_to_cepc: "0000-0000-0000-0000-0000",
      related_party: nil,
      related_energy_band: "d",
      related_assessments: [
        {
          assessmentId: "0000-0000-0000-0000-5555",
          assessmentStatus: "ENTERED",
          assessmentType: "RdSAP",
          assessmentExpiryDate: "2030-05-04",
        },
        {
          assessmentId: "9457-0000-0000-0000-2000",
          assessmentStatus: "ENTERED",
          assessmentType: "CEPC-RR",
          assessmentExpiryDate: "2026-05-04",
        },
      ],
      company_details: {
        name: "Joe Bloggs Ltd", address: "123 My Street, My City, AB3 4CD"
      }
    )
      body = {
        data: {
          typeOfAssessment: "CEPC-RR",
          assessmentId: assessment_id,
          reportType: "4",
          dateOfExpiry: date_of_expiry,
          dateOfRegistration: "2020-05-04",
          relatedCertificate: linked_to_cepc,
          relatedAssessments: related_assessments,
          address: {
            addressId: "UPRN-000000000000",
            addressLine1: "1 Lonely Street",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "Post-Town0",
            postcode: "A0 0AA",
          },
          assessor: {
            schemeAssessorId: "SPEC000000",
            name: "Mrs Report Writer",
            registeredBy: { name: "quidos", schemeId: 3 },
            companyDetails: company_details,
            contactDetails: { email: "a@b.c", telephone: "07921921369" },
          },
          shortPaybackRecommendations: [
            {
              code: "1",
              text:
                "Consider replacing T8 lamps with retrofit T5 conversion kit.",
              cO2Impact: "HIGH",
            },
            {
              code: "3",
              text:
                "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
              cO2Impact: "LOW",
            },
          ],
          mediumPaybackRecommendations: [
            {
              code: "2",
              text: "Add optimum start/stop to the heating system.",
              cO2Impact: "MEDIUM",
            },
          ],
          longPaybackRecommendations: [
            {
              code: "3",
              text: "Consider installing an air source heat pump.",
              cO2Impact: "HIGH",
            },
          ],
          otherRecommendations: [
            { code: "4", text: "Consider installing PV.", cO2Impact: "HIGH" },
          ],
          technicalInformation: {
            floorArea: "10",
            buildingEnvironment: "Natural Ventilation Only",
            calculationTool: "Calculation-Tool0",
          },
          relatedPartyDisclosure: related_party,
          energyBandFromRelatedCertificate: related_energy_band,
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_dec(
      assessment_id: "0000-0000-0000-0000-0001",
      date_of_expiry: "2030-01-01",
      related_assessments: [
        {
          assessmentExpiryDate: "2026-05-04",
          assessmentId: "0000-0000-0000-0000-0001",
          assessmentStatus: "ENTERED",
          assessmentType: "DEC",
        },
        {
          assessmentExpiryDate: "2002-07-01",
          assessmentId: "0000-0000-0000-0000-0002",
          assessmentStatus: "EXPIRED",
          assessmentType: "CEPC-RR",
        },
      ],
      related_party: nil
    )
      body = {
        data: {
          typeOfAssessment: "DEC",
          assessmentId: assessment_id,
          reportType: "1",
          dateOfExpiry: date_of_expiry,
          address: {
            addressId: "UPRN-000000000001",
            addressLine1: "2 Lonely Street",
            addressLine2: "Something road",
            addressLine3: "Place area",
            addressLine4: "General grid",
            town: "Post-Town1",
            postcode: "A0 0AA",
          },
          currentAssessment: {
            date: "2020-01-01",
            energyEfficiencyRating: "1",
            energyEfficiencyBand: "a",
            heatingCo2: "3",
            electricityCo2: "7",
            renewablesCo2: "0",
          },
          year1Assessment: {
            date: "2019-01-01",
            energyEfficiencyRating: "24",
            energyEfficiencyBand: "a",
            heatingCo2: "5",
            electricityCo2: "10",
            renewablesCo2: "1",
          },
          year2Assessment: {
            date: "2018-01-01",
            energyEfficiencyRating: "40",
            energyEfficiencyBand: "b",
            heatingCo2: "10",
            electricityCo2: "15",
            renewablesCo2: "2",
          },
          technicalInformation: {
            mainHeatingFuel: "Natural Gas",
            buildingEnvironment: "Heating and Natural Ventilation",
            floorArea: "99",
            assetRating: "1",
            annualEnergyUseFuelThermal: "11",
            annualEnergyUseElectrical: "12",
            typicalThermalUse: "13",
            typicalElectricalUse: "14",
            renewablesFuelThermal: "15",
            renewablesElectrical: "16",
          },
          administrativeInformation: {
            calculationTool: "DCLG, ORCalc, v3.6.3",
            issueDate: "2020-05-14",
            relatedPartyDisclosure: related_party,
            relatedRrn: "4192-1535-8427-8844-6702",
          },
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            registeredBy: { name: "quidos", schemeId: 1 },
            companyDetails: {
              address: "123 My Street, My City, AB3 4CD", name: "Joe Bloggs Ltd"
            },
            contactDetails: {
              email: "test@testscheme.com", telephone: "012345"
            },
          },
          relatedAssessments: related_assessments,
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_dec_rr(
      assessment_id: "0000-0000-0000-0000-0001",
      date_of_expiry: "2030-01-01",
      related_assessments: [
        {
          assessmentId: "0000-0000-0000-0000-5555",
          assessmentStatus: "ENTERED",
          assessmentType: "RdSAP",
          assessmentExpiryDate: "2030-05-04",
        },
        {
          assessmentId: "9457-0000-0000-0000-2000",
          assessmentStatus: "ENTERED",
          assessmentType: "DEC-RR",
          assessmentExpiryDate: "2026-05-04",
        },
        {
          assessmentId: "9457-0000-0000-0000-2001",
          assessmentStatus: "EXPIRED",
          assessmentType: "DEC-RR",
          assessmentExpiryDate: "2019-05-04",
        },
      ]
    )
      body = {
        data: {
          typeOfAssessment: "DEC-RR",
          assessmentId: assessment_id,
          reportType: "2",
          dateOfExpiry: date_of_expiry,
          address: {
            addressId: "90806560123",
            addressLine1: "1 Lonely Street",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "Post-Town0",
            postcode: "A0 0AA",
          },
          assessor: {
            name: "John Howard",
            schemeAssessorId: "SPEC000000",
            registeredBy: { name: "test scheme", schemeId: 1 },
            companyDetails: {
              address: "123 My Street, My City, AB3 4CD", name: "Joe Bloggs Ltd"
            },
          },
          relatedAssessments: related_assessments,
          shortPaybackRecommendations: [
            {
              code: "1",
              text:
                "Consider thinking about maybe possibly getting a solar panel but only one.",
              cO2Impact: "MEDIUM",
            },
            {
              code: "2",
              text:
                "Consider introducing variable speed drives (VSD) for fans, pumps and compressors.",
              cO2Impact: "LOW",
            },
          ],
          mediumPaybackRecommendations: [
            {
              code: "3",
              text:
                "Engage experts to propose specific measures to reduce hot waterwastage and plan to carry this out.",
              cO2Impact: "LOW",
            },
          ],
          longPaybackRecommendations: [
            {
              code: "4",
              text: "Consider replacing or improving glazing.",
              cO2Impact: "LOW",
            },
          ],
          otherRecommendations: [
            { code: "5", text: "Add a big wind turbine.", cO2Impact: "HIGH" },
          ],
          energyBandFromRelatedCertificate: "a",
          relatedRrn: "0000-0000-0000-0000-1111",
          technicalInformation: {
            occupier: "City Council",
            propertyType: "University campus",
            buildingEnvironment: "Heating and natural ventilation",
            renewableSources: "Renewable energy source",
            discountedEnergy: "Separable energy use",
            floorArea: "935",
            dateOfIssue: "2010-09-22",
            calculationTool: "DCLG, ORCalc, v3.6.2",
            inspectionType: "Physical",
          },
          siteServiceOne: { description: "Electricity", quantity: "751445" },
          siteServiceTwo: { description: "Gas", quantity: "72956" },
          siteServiceThree: { description: "Not used", quantity: "0" },
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_sap(*args)
      fetch_rdsap(args)
    end

    def self.fetch_rdsap(
      assessment_id,
      current_rating = 90,
      current_band = "b",
      recommended_improvements = false,
      current_carbon_emission = "2.4",
      potential_carbon_emission = "1.4",
      impact_of_loft_insulation = -79,
      impact_of_cavity_insulation = -67,
      impact_of_solid_wall_insulation = -69,
      related_party_disclosure_text = nil,
      related_party_disclosure_number = 1,
      property_summary = nil,
      type_of_assessment = "RdSAP",
      energy_performance_rating_improvement = 76,
      green_deal_plan = nil,
      estimatedEnergyCost = nil,
      potentialEnergySaving = nil,
      energy_performance_band_improvement = "c"
    )
      FetchAssessmentSummary::AssessmentSummaryErrorStub.fetch(assessment_id)
      property_summary ||= generate_property_summary
      green_deal_plan ||= generate_green_deal_plan

      if assessment_id == "1111-1111-1111-1111-1112"
        body = {
          "data": {
            "dateOfAssessment": "2020-05-04",
            "dateRegistered": "2020-05-04",
            "dwellingType": "Dwelling-Type0",
            "typeOfAssessment": "RdSAP",
            "totalFloorArea": 0.0,
            "assessmentId": "1111-1111-1111-1111-1112",
            "currentEnergyEfficiencyRating": 50,
            "potentialEnergyEfficiencyRating": 50,
            "currentCarbonEmission": "4.4",
            "potentialCarbonEmission": "3.4",
            "postcode": "A0 0AA",
            "dateOfExpiry": "2030-05-04",
            "addressLine1": "1 Some Street",
            "addressLine2": "",
            "addressLine3": "",
            "addressLine4": "",
            "town": "Post-Town1",
            estimatedEnergyCost: estimatedEnergyCost,
            potentialEnergySaving: potentialEnergySaving,
            "heatDemand": {
              "currentSpaceHeatingDemand": 30.0,
              "currentWaterHeatingDemand": 60.0,
              "impactOfLoftInsulation": -8,
              "impactOfCavityInsulation": -12,
              "impactOfSolidWallInsulation": -16,
            },
            "currentEnergyEfficiencyBand": "e",
            "potentialEnergyEfficiencyBand": "e",
            "relatedPartyDisclosureText": "Financial interest in the property",
            "relatedPartyDisclosureNumber": nil,
            "propertySummary": [],
            "relatedAssessments": [],
            "recommendedImprovements": [
              {
                "sequence": 0,
                "improvementCode": "",
                "improvementTitle": "Fix the boiler",
                "improvementDescription":
                  "An informative description of how to fix the boiler",
                "indicativeCost": "",
                "typicalSaving": "0.0",
                "improvementCategory": "6",
                "improvementType": "Z3",
                "energyPerformanceRatingImprovement":
                  energy_performance_rating_improvement,
                "energyPerformanceBandImprovement":
                  energy_performance_band_improvement,
                "environmentalImpactRatingImprovement": 50,
                "greenDealCategoryCode": "1",
              },
              {
                "sequence": 1,
                "improvementCode": "1",
                "improvementTitle": "",
                "improvementDescription": "",
                "indicativeCost": "",
                "typicalSaving": "0.1",
                "improvementCategory": "2",
                "improvementType": "Z2",
                "energyPerformanceRatingImprovement": 60,
                "energyPerformanceBandImprovement": "e",
                "environmentalImpactRatingImprovement": 64,
                "greenDealCategoryCode": "3",
              },
            ],
            "assessor": {
              "firstName": "Kevin",
              "lastName": "Keenoy",
              "registeredBy": { "name": "Quidos", "schemeId": 6 },
              "schemeAssessorId": "3",
              "dateOfBirth": "1994-01-01",
              "contactDetails": {
                "email": "kevin.keenoy@epb-assessors.com",
                "telephoneNumber": "04150859",
              },
              "searchResultsComparisonPostcode": "TQ11 0EG",
              "qualifications": {
                "domesticSap": "INACTIVE",
                "domesticRdSap": "ACTIVE",
                "nonDomesticSp3": "ACTIVE",
                "nonDomesticCc4": "ACTIVE",
                "nonDomesticDec": "INACTIVE",
                "nonDomesticNos3": "ACTIVE",
                "nonDomesticNos4": "ACTIVE",
                "nonDomesticNos5": "INACTIVE",
              },
            },
          },
          "meta": {},
        }
      else
        recommended_improvements =
          if recommended_improvements
            [
              {
                sequence: 3,
                indicativeCost: "£200 - £500",
                typicalSaving: 100.00,
                improvementCode: "1",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 96,
                energyPerformanceBandImprovement: "a",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 1,
                indicativeCost: "£500 - £1000",
                typicalSaving: 900.00,
                improvementCode: "2",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 60,
                energyPerformanceBandImprovement: "d",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 2,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 4,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 5,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 6,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 7,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 8,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 70,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 9,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 10,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                energyPerformanceBandImprovement: "c",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 11,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 99,
                energyPerformanceBandImprovement: "a",
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
            ]
          else
            []
          end

        body = {
          data: {
            assessor: {
              firstName: "Test",
              lastName: "Boi",
              registeredBy: { name: "Elmhurst Energy", schemeId: 1 },
              schemeAssessorId: "TESTASSESSOR",
              dateOfBirth: "2019-12-04",
              contactDetails: {
                telephoneNumber: "12345678901", email: "test.boi@quidos.com"
              },
              searchResultsComparisonPostcode: "SW1A 2AA",
              qualifications: { domesticRdSap: "ACTIVE" },
            },
            assessmentId: assessment_id,
            dateRegistered: "2020-01-05",
            dateOfExpiry: "2030-01-05",
            dateOfAssessment: "2020-01-02",
            dwellingType: "Top floor flat",
            typeOfAssessment: type_of_assessment,
            totalFloorArea: 150,
            currentEnergyEfficiencyRating: current_rating,
            currentEnergyEfficiencyBand: current_band,
            currentCarbonEmission: current_carbon_emission,
            potentialCarbonEmission: potential_carbon_emission,
            potentialEnergyEfficiencyRating: 99,
            potentialEnergyEfficiencyBand: "a",
            postcode: "SW1B 2BB",
            addressLine1: "Flat 33",
            addressLine2: "2 Marsham Street",
            addressLine3: "",
            addressLine4: "",
            town: "London",
            estimatedEnergyCost: "689.83",
            potentialEnergySaving: "174.00",
            heatDemand: {
              currentSpaceHeatingDemand: 222,
              currentWaterHeatingDemand: 321,
              impactOfLoftInsulation: impact_of_loft_insulation,
              impactOfCavityInsulation: impact_of_cavity_insulation,
              impactOfSolidWallInsulation: impact_of_solid_wall_insulation,
            },
            recommendedImprovements: recommended_improvements,
            relatedPartyDisclosureText: related_party_disclosure_text,
            relatedPartyDisclosureNumber: related_party_disclosure_number,
            propertySummary: property_summary,
            greenDealPlan: green_deal_plan,
            relatedAssessments: [
              {
                assessmentExpiryDate: "2006-05-04",
                assessmentId: "0000-0000-0000-0000-0001",
                assessmentStatus: "EXPIRED",
                assessmentType: "RdSAP",
              },
              {
                assessmentExpiryDate: "2002-07-01",
                assessmentId: "0000-0000-0000-0000-0002",
                assessmentStatus: "EXPIRED",
                assessmentType: "CEPC-RR",
              },
              {
                assessmentId: "9024-0000-0000-0000-0000",
                assessmentStatus: "CANCELLED",
                assessmentType: "RdSAP",
                assessmentExpiryDate: "2030-05-04",
              },
            ],
          },
        }
      end

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.generate_green_deal_plan
      {
        greenDealPlanId: "ABC123456DEF",
        startDate: "2020-01-30",
        endDate: "2030-02-28",
        providerDetails: {
          name: "The Bank",
          telephone: "0800 0000000",
          email: "lender@example.com",
        },
        interest: { rate: 12.3, fixed: true },
        chargeUplift: { amount: 1.25, date: "2025-03-29" },
        ccaRegulated: true,
        structureChanged: false,
        measuresRemoved: false,
        measures: [
          {
            sequence: 0,
            measureType: "Loft insulation",
            product: "WarmHome lagging stuff (TM)",
            repaidDate: "2025-03-29",
          },
          {
            sequence: 1,
            measureType: "Double glazing",
            product: "Not applicable",
          },
        ],
        charges: [
          {
            sequence: 0,
            startDate: "2020-03-29",
            endDate: "2030-03-29",
            dailyCharge: "0.33",
          },
          {
            sequence: 1,
            startDate: "2020-03-29",
            endDate: "2030-03-29",
            dailyCharge: "0.01",
          },
        ],
        savings: [
          { fuelCode: "39", fuelSaving: 23_253, standingChargeFraction: 0 },
          { fuelCode: "40", fuelSaving: -6331, standingChargeFraction: -0.9 },
          { fuelCode: "41", fuelSaving: -15_561, standingChargeFraction: 0 },
        ],
        estimatedSavings: 1566,
      }
    end

    def self.generate_property_summary
      [
        { name: "wall", description: "Many walls", energyEfficiencyRating: 2 },
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
      ]
    end
  end
end
