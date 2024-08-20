# frozen_string_literal: true

require_relative "./shared_language_toggle"
describe "Acceptance::AirConditioningInspectionReport", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/0000-0000-0000-0000-9999" }

  context "when an ac report exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
        assessment_id: "0000-0000-0000-0000-9999",
      )
    end

    it "shows the page title" do
      expect(response.body).to have_css "h1",
                                        text: "Air conditioning inspection report"
    end

    include_examples "show language toggle"

    it "has a tab content that shows the page title" do
      expect(response.body).to include(
        " <title>Air conditioning inspection report – Find an energy certificate – GOV.UK</title>",
      )
    end

    it "shows the share certificate section" do
      expect(response.body).to have_css "h2", text: "Share this report"
      expect(response.body).to have_link "Email"
      expect(response.body).to have_button "Copy link to clipboard", visible: :all
      expect(response.body).to have_link "Print", visible: :all
    end

    it "shows the summary section" do
      expect(response.body).to have_css "span", text: "The Bank Plc"
      expect(response.body).to have_css "span",
                                        text: "49-51 Northumberland Street"
      expect(response.body).to have_css "span", text: "NE1 7AF"
      expect(response.body).to have_css "label", text: "Report number"
      expect(response.body).to have_css "span", text: "0000-0000-0000-0000-9999"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "span", text: "6 February 2025"
    end

    it "can show the Assessor's details section" do
      expect(response.body).to have_css "h2", text: "Assessor’s details"
      expect(response.body).to have_css "dt", text: "Assessor’s name"
      expect(response.body).to have_css "dd", text: "TEST NAME BOI"
      expect(response.body).to have_css "dt", text: "Assessor ID"
      expect(response.body).to have_css "dd", text: "SPEC000000"
      expect(response.body).to have_css "dt", text: "Accreditation scheme"
      expect(response.body).to have_css "dd", text: "Quidos"
      expect(response.body).to have_css "dt",
                                        text: "Accreditation scheme telephone"
      expect(response.body).to have_css "dd", text: "01225 667 570"
      expect(response.body).to have_css "dt", text: "Accreditation scheme email"
      expect(response.body).to have_css "dd", text: "info@quidos.co.uk"
      expect(response.body).to have_css "dt", text: "Employer/Trading name"
      expect(response.body).to have_css "dd", text: "Joe Bloggs Ltd"
      expect(response.body).to have_css "dt", text: "Employer/Trading address"
      expect(response.body).to have_css "dd",
                                        text: "123 My Street, My City, AB3 4CD"
    end

    it "can show the Executive summary section" do
      expect(response.body).to have_css "h2", text: "Executive summary"
      expect(response.body).to have_css "pre", text: "My\nSummary\t\tInspected"
    end

    it "can show the key recommendations section" do
      expect(response.body).to have_css "h2", text: "Key recommendations"
      expect(response.body).to have_css "h3", text: "Efficiency"
      expect(response.body).to have_css "p",
                                        text: "A way to improve your efficiency"
      expect(response.body).to have_css "p",
                                        text: "A second way to improve efficiency"
      expect(response.body).to have_css "h3", text: "Maintenance"
      expect(response.body).to have_css "p", text: "Text2"
      expect(response.body).to have_css "h3", text: "Control"
      expect(response.body).to have_css "p", text: "Text4"
      expect(response.body).to have_css "h3", text: "Management"
      expect(response.body).to have_css "p", text: "Text6"
    end

    it "can show the subsystems section" do
      expect(response.body).to have_css "h2", text: "Subsystems inspected"
      expect(response.body).to have_css "h3",
                                        text: "VOL001/SYS001 R410A Inverter Split Systems to Sales Area"
      expect(response.body).to have_css "dt", text: "Volume definitions"
      expect(response.body).to have_css "dd", text: "VOL001 The Shop"
      expect(response.body).to have_css "dt", text: "Description"
      expect(response.body).to have_css "dd",
                                        text:
                                          "This sub system comprised of; 4Nr 10kW R410A Mitsubishi Heavy Industries inverter driven split AC condensers."
      expect(response.body).to have_css "dt",
                                        text: "Effective rated cooling output"
      expect(response.body).to have_css "dd", text: "40 kW"
      expect(response.body).to have_css "dt", text: "Area served"
      expect(response.body).to have_css "dd", text: "Sales Area"
      expect(response.body).to have_css "dt", text: "Inspection date"
      expect(response.body).to have_css "dd", text: "20 May 2019"
      expect(response.body).to have_css "dt", text: "Cooling plant count"
      expect(response.body).to have_css "dd", text: "4"
      expect(response.body).to have_css "dt", text: "AHU count"
      expect(response.body).to have_css "dd", text: "0"
      expect(response.body).to have_css "dt", text: "Terminal units count"
      expect(response.body).to have_css "dd", text: "4"
      expect(response.body).to have_css "dt", text: "Sub system controls count"
      expect(response.body).to have_css "dd", text: "5"
    end

    it "can show the pre-inspection section" do
      expect(response.body).to have_css "h2",
                                        text: "Pre-inspection records requested"
      expect(response.body).to have_css "h3", text: "Essential records"
      expect(response.body).to have_css "h3", text: "Desirable records"
      expect(response.body).to have_css "h3", text: "Optional records"
    end

    it "can show the air handling systems" do
      expect(response.body).to have_css "h2", text: "Air handling systems"
      expect(response.body).to have_css "h3", text: "Air handling system 1"
      expect(response.body).to have_css "dt", text: "Component"
      expect(response.body).to have_css "dd", text: "VENT1 Heat recovery"
      expect(response.body).to have_css "dt", text: "Unit"
      expect(response.body).to have_css "dd", text: "123"
      expect(response.body).to have_css "dt", text: "Areas or systems served"
      expect(response.body).to have_css "dd", text: "Corridor"
      expect(response.body).to have_css "dt", text: "Discrepancies noted"
      expect(response.body).to have_css "dd", text: "None"
      expect(response.body).to have_css "dt", text: "Year installed"
      expect(response.body).to have_css "dd", text: "2016"
      expect(response.body).to have_css "dt", text: "Location of plant"
      expect(response.body).to have_css "dd", text: "Above corridor ceiling"
      expect(response.body).to have_css "dt", text: "Manufacturer"
      expect(response.body).to have_css "dd", text: "NUAIRE"
      expect(response.body).to have_css "dt",
                                        text: "Systems served from cooling plant"
      expect(response.body).to have_css "dd", text: "Corridor"
      expect(response.body).to have_css "p",
                                        text:
                                          "The calculation used was: 464 watts x 70% - 0.311/400 = 8.12 w/ltr."
      expect(response.body).to have_css "h4",
                                        text: "CS6.1, CS6.2, CS6.3: Filters"
      expect(response.body).to have_css "h5",
                                        text: "Are air intake and filter conditions acceptable?"
      expect(response.body).to have_css "h5",
                                        text:
                                          "Have filters been changed according to current industry guidance?"
      expect(response.body).to have_css "h5",
                                        text:
                                          "Is the filter differential pressure gauge, where fitted, working?"
      expect(response.body).to have_css "p",
                                        text:
                                          "Originally changed on an annual basis but now upgraded to six monthly."
      expect(response.body).to have_css "p",
                                        text:
                                          "The assessor made the following notes and recommendations:"
      expect(response.body).to have_css "li",
                                        text: "Change this more frequently"
    end

    it "can show the terminal units" do
      expect(response.body).to have_css "h2", text: "Terminal units"
      expect(response.body).to have_css "h3", text: "Terminal unit 1"
      expect(response.body).to have_css "dt", text: "Component"
      expect(response.body).to have_css "dd",
                                        text:
                                          "Indoor wall type split which is part of a multi system with 5 indoor units."
      expect(response.body).to have_css "dt", text: "Unit"
      expect(response.body).to have_css "dd", text: "VOL1/SYS1"
      expect(response.body).to have_css "dt", text: "Description of unit"
      expect(response.body).to have_css "dd", text: "VOL1/SYS1/a"
      expect(response.body).to have_css "dt",
                                        text: "Cooling plant serving terminal unit"
      expect(response.body).to have_css "dd", text: "Cooling system"
      expect(response.body).to have_css "dt", text: "Manufacturer"
      expect(response.body).to have_css "dd", text: "Mitsubishi Electric"
      expect(response.body).to have_css "dt", text: "Year installed"
      expect(response.body).to have_css "dd", text: "2011"
      expect(response.body).to have_css "dt", text: "Area served"
      expect(response.body).to have_css "dd", text: "ICT Suite"
      expect(response.body).to have_css "dt", text: "Discrepancies noted"
      expect(response.body).to have_css "dd", text: "None"
      expect(response.body).to have_css "p",
                                        text:
                                          "Internal refrigerant pipe work connected to this terminal unit was enclosed and not accessible during the inspection."
      expect(response.body).to have_css "p",
                                        text:
                                          "There is no ductwork associated with this type of terminal unit."
    end

    it "can show the system controls" do
      expect(response.body).to have_css "h2", text: "System controls"
      expect(response.body).to have_css "h3",
                                        text:
                                          "Control for VOL001/SYS001 R410A Inverter Split Systems to Sales Area"
    end

    it "can show the inspection certificate" do
      expect(response.body).to have_css "h2", text: "Inspection certificate"
      expect(response.body).to have_css "a",
                                        text:
                                          "See the air conditioning inspection certificate for this property."
    end

    context "when there are no subsystems" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
          assessment_id: "0000-0000-0000-0000-9999",
          sub_systems: [],
        )
      end

      it "does not show the Subsystems inspected section" do
        expect(response.body).not_to have_css "h2", text: "Subsystems inspected"
      end
    end

    it "can show the cooling plant section" do
      expect(response.body).to have_css "h2", text: "Cooling plants"
      expect(response.body).to have_css "h3", text: "Cooling plant"
      expect(response.body).to have_css "dt", text: "Unit Identifier"
      expect(response.body).to have_css "dd",
                                        text: "VOL001/SYS001 R410A Inverter Split Systems to Sales Are"
      expect(response.body).to have_css "dt", text: "Component Identifier"
      expect(response.body).to have_css "dd",
                                        text: "VOL001/SYS001/CP1 Sampled R410A Inverter Split Area (1)"

      expect(response.body).to have_css "h4", text: "Equipment"

      expect(response.body).to have_css "dt",
                                        text: "Rated Cooling Capacity (kW)"
      expect(response.body).to have_css "dd", text: "10"
      expect(response.body).to have_css "dt", text: "Description (type/details)"
      expect(response.body).to have_css "dd", text: "Single Split"
      expect(response.body).to have_css "dt", text: "Location of Cooling Plant"
      expect(response.body).to have_css "dd", text: "Externally on roof"
      expect(response.body).to have_css "dt", text: "Manufacturer"
      expect(response.body).to have_css "dd", text: "Mitsubishi"
      expect(response.body).to have_css "dt", text: "Model/Reference"
      expect(response.body).to have_css "dd", text: "FDC100VN"
      expect(response.body).to have_css "dt", text: "Refrigerant Charge (kg)"
      expect(response.body).to have_css "dd", text: "3"
      expect(response.body).to have_css "dt", text: "Serial Number"
      expect(response.body).to have_css "dd", text: "not visible"
      expect(response.body).to have_css "dt", text: "Refrigerant Type"
      expect(response.body).to have_css "dd", text: "R410A"
      expect(response.body).to have_css "dt", text: "Year Plant Installed"
      expect(response.body).to have_css "dd", text: "2014"
      expect(response.body).to have_css "dt", text: "Areas/Systems Served"
      expect(response.body).to have_css "dd", text: "Sales Area"

      expect(response.body).to have_css "h5",
                                        text:
                                          "Note below any discrepancy between information provided by client and on site information collected, or any information of additional relevance to the cooling plant/system:"
      expect(response.body).to have_css "p", text: "Something more random"

      expect(response.body).to have_css "h4", text: "Approved sections"
      expect(response.body).to have_css "h5",
                                        text:
                                          "Is the insulation on circulation pipe work well fitted and in good order?"
      expect(response.body).to have_css "p",
                                        text: "The condenser is considered suitably located."
      expect(response.body).to have_css "p", text: "No recommendation required."
      expect(response.body).to have_css "dt",
                                        text: "Installed Cooling Capacity (kW)"
      expect(response.body).to have_css "dd", text: "10.0"
      expect(response.body).to have_css "dt",
                                        text: "Occupant Density (m2/person)"
      expect(response.body).to have_css "dd", text: "8.93"
      expect(response.body).to have_css "dt",
                                        text: "Total Floor Area served by this plant(m2)"
      expect(response.body).to have_css "dd", text: "357"
      expect(response.body).to have_css "dt",
                                        text: "Total Occupants served by this plant"
      expect(response.body).to have_css "dd", text: "40"
      expect(response.body).to have_css "dt",
                                        text: "Maximum Instantaneous Heat Gain (W/m2)"
      expect(response.body).to have_css "dd", text: "140.0"
      expect(response.body).to have_css "dt",
                                        text: "The Installed Size is Deemed"
      expect(response.body).to have_css "dd", text: "Less than expected"

      expect(response.body).to have_css "p",
                                        text: "Floor area was measured whilst on site."

      expect(response.body).to have_css "dt", text: "Pre Compressor(°C)"
      expect(response.body).to have_css "dd", text: "22"
      expect(response.body).to have_css "dt", text: "Post Compressor(°C)"
      expect(response.body).to have_css "dd", text: "7"
      expect(response.body).to have_css "dt", text: "Ambient(°C)"
      expect(response.body).to have_css "dd", text: "13"
      expect(response.body).to have_css "dt", text: "The Temperature is Deemed"
      expect(response.body).to have_css "dd", text: "As expected"

      expect(response.body).to have_css "h5",
                                        text: "Are there any signs of a refrigerant leak?"
      expect(response.body).to have_css "p",
                                        text:
                                          "There were no visible signs of a leak observed during the inspection."

      expect(response.body).to have_css "dt",
                                        text:
                                          "Assess the refrigeration compressor(s) and the method of refrigeration capacity control"
      expect(response.body).to have_css "dd",
                                        text: "The capacity control is inverter."

      expect(response.body).to have_css "dt", text: "Refrigerant Type"
      expect(response.body).to have_css "dd", text: "R410A"

      expect(response.body).to have_css "h5",
                                        text: "Montreal/ODS/F-Gas controlled?"
      expect(response.body).to have_css "p",
                                        text:
                                          "There were no visible signs of a leak observed during the inspection."
      expect(response.body).to have_css "p",
                                        text: "R22 is an ODS (Ozone Depleting Substance)"
      expect(response.body).to have_css "p",
                                        text:
                                          "Maintenance contract advised as being in place and would appear satisfactory due to unit condition."
      expect(response.body).to have_css "p",
                                        text: "Yes system appears in good order for age."

      expect(response.body).to have_css "h5",
                                        text:
                                          "Is the refrigeration plant connected to a BEMS that can provide out of range alarms?"
      expect(response.body).to have_css "p",
                                        text: "The system is linked to a Central Controller.",
                                        exact_text: true
      expect(response.body).to have_css "h5",
                                        text:
                                          "Are there any records of air conditioning plant usage or sub-metered energy consumption with expected hours of use per year for the plant?"
      expect(response.body).to have_css "p",
                                        text: "No details available.",
                                        exact_text: true
      expect(response.body).to have_css "h5",
                                        text:
                                          "Is metering installed to enable monitoring of energy consumption of refrigeration plant?"
      expect(response.body).to have_css "p",
                                        text: "Recorded meter reading: 987654321",
                                        exact_text: true
      expect(response.body).to have_css "p",
                                        text: "Separate energy metering for AC systems monitors energy use of air conditioning/comfort cooling systems.",
                                        exact_text: true
      expect(response.body).to have_css "h5",
                                        text: "Is the energy consumption or hours of use excessive?"
      expect(response.body).to have_css "p",
                                        text:
                                          "There were no records of air conditioning plant usage or sub-metered energy consumption with expected hours of use per year for the plant or systems located on site.",
                                        exact_text: true

      expect(response.body).to have_css "h5",
                                        text:
                                          "Is the water flow through cooling towers or evaporative coolers even and efficient, and there is no loss of water?"
      expect(response.body).to have_css "p",
                                        text: "N/A no cooling towers installed to this system"
      expect(response.body).to have_css "h5",
                                        text:
                                          "Is there a management regime in place to ensure that water is regularly checked and treated to ensure that there is no Legionella risk?"
      expect(response.body).to have_css "p",
                                        text: "N/A no cooling towers installed to this site"

      expect(response.body).to have_css "h5",
                                        text:
                                          "Is there separate equipment installed for humidity control?"
      expect(response.body).to have_css "p",
                                        text: "N/A no humidity control installed to this system"

      # Refrigeration notes section
      expect(response.body).to have_css "p",
                                        text:
                                          "Access to the pre and post compressor for this type of system is difficult with a visual inspection; therefore the air on/room temperature and air off temperatures were taken from the indoor unit. (Pre Compressor temperature detailed is therefore the room temperature)."
      expect(response.body).to have_css "p",
                                        text:
                                          "This system could not be brought into operation, this did not give cause for concern as there was no internal temperature demand on the system during the inspection."
    end

    context "when viewing the related certificates section" do
      it "shows the section title" do
        expect(response.body).to have_css(
          "h2",
          text: "Other reports for this property",
        )
      end

      it "shows the related AC-CERT certificates" do
        expect(response.body).to have_link "0000-0000-0000-0000-0002",
                                           href: "/energy-certificate/0000-0000-0000-0000-0002"
      end
    end
  end

  context "when the assessment is fetched in Welsh" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
        assessment_id: "0000-0000-0000-0000-9999",
      )
    end

    let(:response) do
      get "/energy-certificate/0000-0000-0000-0000-9999?lang=cy"
    end

    it "shows the language toggle" do
      expect(response.body).to have_css "ul.language-toggle__list"
      expect(response.body).to have_link "English"
      expect(response.body).not_to have_link "Cymraeg"
    end
  end

  describe "CEPC 6.0 AC report" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
        assessment_id: "0000-0000-0000-0000-9999",
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
    end

    it "can show the records section" do
      expect(response.body).to have_css "h2",
                                        text: "Pre-inspection records requested"
      expect(response.body).to have_css "h3", text: "Essential records"
      expect(response.body).to have_css "h3", text: "Desirable records"
      expect(response.body).to have_css "h3", text: "Optional records"
      expect(response.body).to have_css "p",
                                        text: "For the centralised cooling systems"
      expect(response.body).to have_css "p",
                                        text: "For the packaged cooling systems"
    end

    it "Explains that the detailed notes are not available" do
      expect(response.body).to have_css "p",
                                        text:
                                          "The detailed inspection notes from this report are no longer available online. If you require the detailed inspection notes, contact us at mhclg.digital-services@communities.gov.uk"
    end
  end

  context "when an ac report expires" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
        assessment_id: "0000-0000-0000-0000-9999",
        date_of_expiry: "2010-03-24",
      )
    end

    it "shows the expired summary section" do
      expect(response.body).to have_css "label", text: "This report expired on"
      expect(response.body).to have_css "span", text: "24 March 2010"
    end

    it "shows an expired warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "This report has expired.")
    end
  end

  context "when an ac report is both NI and opted out" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
        assessment_id: "0000-0000-0000-0000-9999",
        postcode: "BT1 1AA",
        opt_out: true,
      )
    end

    it "removes assessor contact details" do
      expect(response.body).to have_css "h2", text: "Assessor’s details"
      expect(response.body).not_to have_css "dt", text: "Assessor’s name"
      expect(response.body).not_to have_css "dd", text: "TEST NAME BOI"
      expect(response.body).not_to have_css "dt", text: "Assessor ID"
      expect(response.body).not_to have_css "dd", text: "SPEC000000"
      expect(response.body).not_to have_css "dt", text: "Employer/Trading name"
      expect(response.body).not_to have_css "dd", text: "Joe Bloggs Ltd"
      expect(response.body).not_to have_css "dt",
                                            text: "Employer/Trading address"
      expect(response.body).not_to have_css "dd",
                                            text: "123 My Street, My City, AB3 4CD"
      expect(response.body).to have_css "dt", text: "Accreditation scheme"
      expect(response.body).to have_css "dd", text: "Quidos"
      expect(response.body).to have_css "dt",
                                        text: "Accreditation scheme telephone"
      expect(response.body).to have_css "dd", text: "01225 667 570"
      expect(response.body).to have_css "dt", text: "Accreditation scheme email"
      expect(response.body).to have_css "dd", text: "info@quidos.co.uk"
    end
  end

  context "when an ac report has been superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_ac_report(
        assessment_id: "0000-0000-0000-0000-1111",
        date_of_expiry: "2012-02-21",
        superseded_by: "0000-1111-2222-3333-4444",
      )
    end

    let(:response) { get "/energy-certificate/0000-0000-0000-0000-1111" }

    it "shows a superseded warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "A new report has replaced this one.")
    end

    it "shows a link to get the get service within the warning message" do
      expect(response.body).to have_css(".govuk-warning-text a")
      expect(response.body).to have_link("See the new report", href: "/energy-certificate/0000-1111-2222-3333-4444")
    end
  end
end
