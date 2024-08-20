# frozen_string_literal: true

require_relative "./shared_language_toggle"
describe "Acceptance::NonDomesticEnergyPerformanceCertificateRecommendationReport",
         type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

  context "when the assessment does not exist" do
    before do
      FetchAssessmentSummary::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
    end

    it "returns status 404" do
      expect(response.status).to eq 404
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end

    it "does not display a back link" do
      expect(response.body).not_to include("Back")
    end
  end

  context "when the assessment exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: nil,
        related_energy_band: "d",
      )
    end

    it "Shows the page title" do
      expect(response.body).to include(
        "Energy performance certificate (EPC) recommendation report",
      )
    end

    include_examples "show language toggle"

    it "has a tab content that shows the page title" do
      expect(response.body).to include(
        " <title>Energy performance certificate (EPC) recommendation report – Find an energy certificate – GOV.UK</title>",
      )
    end

    it "shows the share certificate section" do
      expect(response.body).to have_css "h2", text: "Share this report"
      expect(response.body).to have_link "Email"
      expect(response.body).to have_button "Copy link to clipboard", visible: :all
      expect(response.body).to have_link "Print", visible: :all
    end

    it "Shows the top summary box" do
      expect(response.body).to have_css "span", text: "1 Lonely Street"
      expect(response.body).to have_css "span", text: "Post-Town0"
      expect(response.body).to have_css "span", text: "A0 0AA"
      expect(response.body).to have_css "label", text: "Report number"
      expect(response.body).to have_css "span", text: "1234-5678-1234-5678-1234"
      expect(response.body).to have_css "label", text: "Valid until"
      expect(response.body).to have_css "span", text: "1 January 2030"
    end

    it "Shows the efficiency band from the related cepc" do
      expect(response.body).to have_css "p",
                                        text: "This property’s energy rating is D."
    end

    it "Shows a link to the related CEPC" do
      expect(response.body).to include("/0000-0000-0000-0000-0000")
    end

    it "Shows the recommendations" do
      expect(response.body).to include(
        "Consider replacing T8 lamps with retrofit T5 conversion kit.",
      )
      expect(response.body).to include(
        "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
      )
      expect(response.body).to include(
        "Add optimum start/stop to the heating system.",
      )
      expect(response.body).to include(
        "Consider installing an air source heat pump.",
      )
      expect(response.body).to include("Consider installing PV.")
      expect(response.body).to include("High")
      expect(response.body).to include("Medium")
      expect(response.body).to include("Low")
    end

    it "Shows the building and report details" do
      expect(response.body).to include("4 May 2020")
      expect(response.body).to include("10 square metres")
      expect(response.body).to include("Natural Ventilation Only")
      expect(response.body).to include("Calculation-Tool0")
    end

    it "Shows the assessor details" do
      expect(response.body).to include("Mrs Report Writer")
      expect(response.body).to include("SPEC000000")
      expect(response.body).to include("Quidos")
      expect(response.body).to include("Joe Bloggs Ltd")
      expect(response.body).to include("123 My Street, My City, AB3 4CD")
    end

    it "Shows the related party disclosure" do
      expect(response.body).to include(
        "The assessor has not indicated whether they have a relation to this property",
      )
    end

    it "shows the Other reports for this property" do
      expect(response.body).to have_css "h2",
                                        text: "Other reports for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous reports for this property and they are not listed here, please contact us at mhclg.digital-services@communities.gov.uk or call our helpdesk on 020 3829 0748 (Monday to Friday, 9am to 5pm)."
      expect(response.body).to have_css "dt", text: "Report number"
      expect(response.body).to have_link "9457-0000-0000-0000-2000",
                                         href: "/energy-certificate/9457-0000-0000-0000-2000"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).not_to have_link "0000-0000-0000-0000-5555",
                                             href: "/energy-certificate/0000-0000-0000-0000-5555"
    end
  end

  context "when the assessment is fetched in Welsh" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: nil,
        related_energy_band: "d",
      )
    end

    let(:response) do
      get "/energy-certificate/1234-5678-1234-5678-1234?lang=cy"
    end

    it "shows the language toggle" do
      expect(response.body).to have_css "ul.language-toggle__list"
      expect(response.body).to have_link "English"
      expect(response.body).not_to have_link "Cymraeg"
    end
  end

  context "with a related party disclosure" do
    it "shows the the related party disclosure text" do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        related_party: "1",
      )

      response = get "/energy-certificate/1234-5678-1234-5678-1234"

      expect(response.body).to have_css "dd.govuk-summary-list__value",
                                        text: "The assessor is not related to the owner of the property."
    end
  end

  context "when there are no related assessments" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: "Connected to owner",
        related_energy_band: "d",
        related_assessments: [],
      )
    end

    it "shows the no related reports text" do
      expect(response.body).to have_css "p",
                                        text: "There are no related reports for this property."
    end
  end

  context "when there are no company details" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        company_details: {
          name: nil,
          address: nil,
        },
      )
    end

    it "does not show the employer details" do
      expect(response.body).not_to include("Joe Bloggs Ltd")
      expect(response.body).not_to include("123 My Street, My City, AB3 4CD")
    end
  end

  context "when there is no information about the related CEPC" do
    let(:response) { get "/energy-certificate/1234-5678-1234-5678-9999" }

    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-9999",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: "Connected to owner",
        related_energy_band: nil,
      )
    end

    it "doesnt show the related cepc section" do
      page_without_cepc = get "/energy-certificate/1234-5678-1234-5678-9999"
      expect(page_without_cepc.body).not_to include("Energy rating and EPC")
    end

    it "does not show the superseded warning message" do
      expect(response.body).not_to have_css("div.govuk-warning-text", text: " A new report has replaced this one. See the new certificate")
    end
  end

  context "when the assessment exists but has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2014-06-21",
      )
    end

    it "Shows the expired top summary box" do
      expect(response.body).to have_css "label", text: "This report expired on"
      expect(response.body).to have_css "span", text: "21 June 2014"
    end
  end

  context "when a non domestic report is both NI and opted out" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        postcode: "BT1 1AA",
        opt_out: true,
      )
    end

    it "removes assessor contact details" do
      expect(response.body).not_to include("Mrs Report Writer")
      expect(response.body).not_to include("07921921369")
      expect(response.body).not_to include("a@b.c")
      expect(response.body).not_to include("SPEC000000")
      expect(response.body).not_to include("Joe Bloggs Ltd")
      expect(response.body).not_to include("123 My Street, My City, AB3 4CD")
      expect(response.body).not_to include(
        "The assessor has not indicated whether they have a relation to this property",
      )
      expect(response.body).to include("Quidos")
    end
  end

  context "when the certificate has been superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2030-01-01",
        linked_to_cepc: "0000-0000-0000-0000-0000",
        related_party: nil,
        related_energy_band: "d",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "shows the superseded warning message" do
      expect(response.body).to have_css("div.govuk-warning-text", text: /Warning/)
      expect(response.body).to have_css("div.govuk-warning-text", text: /A new report has replaced this one/)
    end

    it "the warning is hidden for print using the existing css definition" do
      expect(response.body).to include('<div class="govuk-warning-text"')
    end

    it "shows the superseded link" do
      expect(response.body).to have_link("See the new report", href: "/energy-certificate/0000-0000-0000-0000-5555")
    end
  end

  context "when the certificate has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
        assessment_id: "1234-5678-1234-5678-1234",
        date_of_expiry: "2010-01-05",
        related_energy_band: "b",
        superseded_by: nil,
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "shows the expired on message in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box label", text: "This report expired on")
    end

    it "shows the expired date in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box span", text: "5 January 2010")
    end

    it "shows an expired warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "This report has expired.")
    end

    it "shows a link to get the get service within the warning message" do
      expect(response.body).to have_css(".govuk-warning-text a")
      expect(response.body).to have_link("get a new certificate and report", href: "http://getting-new-energy-certificate.local.gov.uk:9393/")
    end

    context "when the expired epc has been superseded" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_cepc_rr(
          assessment_id: "1234-5678-1234-5678-1234",
          date_of_expiry: "2010-01-05",
          related_energy_band: "b",
        )
      end

      it "shows an superseded warning message" do
        expect(response.body).to have_css(".govuk-warning-text", text: "A new report has replaced this one")
      end

      it "does not show an expired warning message" do
        expect(response.body).not_to have_css(".govuk-warning-text", text: "This report has expired")
      end
    end
  end
end
