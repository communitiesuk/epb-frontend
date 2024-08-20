# frozen_string_literal: true

require_relative "./content_security_policy_behaviour"
require_relative "./shared_language_toggle"

describe "Acceptance::NonDomesticEnergyPerformanceCertificate",
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
  end

  context "when the assessment exists" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                          "1234-5678-1234-5678-1234",
                                                        energy_efficiency_band:
                                                          "b"
    end

    it "returns status 200" do
      expect(response.status).to eq 200
    end

    it "has a tab content that shows the page title" do
      expect(response.body).to include(
        " <title>Energy performance certificate (EPC) – Find an energy certificate – GOV.UK</title>",
      )
    end

    it "shows the non-domestic energy performance certificate title heading" do
      dom = Capybara.string(response.body)
      heading = dom.find("h1")
      expect(heading.text).to eq "Energy performance certificate (EPC)"
    end

    it_behaves_like "all script elements have nonce attributes"
    it_behaves_like "all style elements have nonce attributes"

    include_examples "show language toggle"

    describe "viewing the summary section" do
      it "shows the address summary" do
        expect(response.body).to have_css "p.epc-address",
                                          text: "Flat 332 Marsham StreetLondonSW1B 2BB"
      end

      it "shows the energy rating title" do
        expect(response.body).to include(
          '<p class="epc-rating-title govuk-body">Energy rating</p>',
        )
      end

      it "shows the current energy energy efficiency band" do
        expect(response.body).to include(
          '<p class="epc-rating-result govuk-body">B</p>',
        )
      end

      it "shows the date of expiry" do
        expect(response.body).to have_css "label", text: "Valid until"
        expect(response.body).to have_css "p", text: "5 January 2030"
      end

      it "shows the certificate number label" do
        expect(response.body).to include("<label>Certificate number</label>")
      end

      it "shows the certificate number" do
        expect(response.body).to include('<p class="govuk-body govuk-!-font-weight-bold">1234-5678-1234-5678-1234</p>')
      end

      it "shows the share certificate section" do
        expect(response.body).to have_css "h2", text: "Share this certificate"
        expect(response.body).to have_link "Email"
        expect(response.body).to have_button "Copy link to clipboard", visible: :all
        expect(response.body).to have_link "Print", visible: :all
      end

      it "shows the property type" do
        expect(response.body).to include("B1 Offices and Workshop businesses")
      end

      it "shows the total floor area" do
        expect(response.body).to include("403 square metres")
      end
    end

    context "when viewing the Rules on letting this property section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Rules on letting this property</h2>',
        )
      end

      it "shows the letting info text", :aggregate_failures do
        expect(response.body).to include(
          '<p class="govuk-body">Properties can be let if they have an energy rating from A+ to E.</p>',
        )

        expect(response.body).not_to include(
          '<p class="govuk-body">If a property has an energy rating of F or G, the landlord cannot grant a tenancy to new or existing tenants, unless an exemption has been registered.</p>',
        )

        expect(response.body).not_to include(
          '<p class="govuk-body">From 1 April 2023, landlords will not be allowed to continue letting a non-domestic property on an existing lease if that property has an energy rating of F or G.</p>',
        )
      end

      it "shows the guidance for landlords link" do
        expect(response.body).to include(
          '<p class="govuk-body">You can read <a class="govuk-link" href="https://www.gov.uk/government/publications/non-domestic-private-rented-property-minimum-energy-efficiency-standard-landlord-guidance">guidance for landlords on the regulations and exemptions</a>.</p>',
        )
      end
    end

    context "when the property has an energy rating of F/G" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                            "1234-5678-1234-5678-1234",
                                                          energy_efficiency_band:
                                                            "g"
      end

      it "shows the letting info warning text" do
        expect(response.body).to include(
          '<strong class="govuk-warning-text__text"><span class="govuk-visually-hidden">Warning</span>You may not be able to let this property.</strong>',
        )
      end

      it "shows the letting info text" do
        expect(response.body).to include(
          '<p class="govuk-body">This property has an energy rating of G. The landlord cannot grant a tenancy to new or existing tenants, unless an exemption has been registered.</p>',
        )

        expect(response.body).to include(
          '<p class="govuk-body">From 1 April 2023, landlords will not be allowed to continue letting a non-domestic property on an existing lease if that property has an energy rating of F or G.</p>',
        )
      end

      it "shows the guidance for landlords link" do
        expect(response.body).to include(
          '<p class="govuk-body">You can read <a class="govuk-link" href="https://www.gov.uk/government/publications/non-domestic-private-rented-property-minimum-energy-efficiency-standard-landlord-guidance">guidance for landlords on the regulations and exemptions</a>.</p>',
        )
      end

      it "shows the recommendation text" do
        expect(response.body).to include(
          '<p class="govuk-body">Properties can be let if they have an energy rating from A+ to E. The <a class="govuk-link" href="#related_report">recommendation report</a> sets out changes you can make to improve the property’s rating.</p>',
        )
      end
    end

    context "when the property is in Northern Ireland and has an energy rating of F/G" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                            "1234-5678-1234-5678-1234",
                                                          energy_efficiency_band:
                                                            "g",
                                                          postcode: "BT4 3WS"
      end

      it "shows the letting info warning text" do
        expect(response.body).not_to include(
          '<h2 class="govuk-heading-l">Rules on letting this property</h2>',
        )
      end
    end

    context "when viewing the Energy efficiency rating for this building section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Energy rating and score</h2>',
        )
      end

      it "shows the current energy rating text" do
        expect(response.body).to have_css "p",
                                          text: "This property’s energy rating is B."
      end

      it "shows the SVG alternate text title" do
        expect(response.body).to include(
          '<title id="svg-title">Energy efficiency chart</title>',
        )
      end

      it "shows the SVG alternate text description" do
        expect(response.body).to include(
          '<desc id="svg-desc">This property’s energy rating is B with a score of 35. Properties get a rating from A+ to G and a score. Rating B is for a score of 26 to 50. The ratings and scores are as follows from best to worst. Rating A+ is for a score below zero. Rating A is for a score of zero to 25. Rating B is for a score of 26 to 50. Rating C is for a score of 51 to 75. Rating D is for a score of 76 to 100. Rating E is for a score of 101 to 125. Rating F is for a score of 126 to 150. Rating G is for a score over 150.</desc>',
        )
      end

      it "shows the net zero carbon emissions text" do
        expect(response.body).to have_css "text", text: "Net zero CO2"
      end

      it "shows the SVG with energy ratings" do
        expect(response.body).to include('<svg width="615"')
      end

      it "shows the SVG with energy rating band numbers" do
        expect(response.body).to include('<tspan x="8" y="105">0-25</tspan>')
      end

      it "shows the energy rating description" do
        expect(response.body).to include(
          '<p class="govuk-body govuk-!-margin-top-3">Properties get a rating from A+ (best) to G (worst) and a score.</p>',
        )
      end

      it "shows the energy rating score description" do
        expect(response.body).to include(
          "The better the rating and score, the lower your property’s carbon emissions are likely to be.",
        )
      end

      it "shows the how this property compares to others section" do
        expect(response.body).to include("How this property compares to others")
        expect(response.body).to include("28 B")
        expect(response.body).to include("81 D")
      end

      it "shows the breakdown of this buildings energy performance section" do
        expect(response.body).to include(
          ">Breakdown of this property’s energy performance</h2>",
        )
        expect(response.body).to include("Natural Gas")
        expect(response.body).to include("Air Conditioning")
        expect(response.body).to include("3")
        expect(response.body).to include("67.09")
        expect(response.body).to include("413\n") # Check the value is rounded
      end

      it "shows the primary energy use explanation" do
        expect(response.body).to include("About primary energy use")
      end

      it "shows the contact section" do
        expect(response.body).to include(
          ">Who to contact about this certificate</h2>",
        )
        expect(response.body).to include(">Contacting the assessor</h3>")
        expect(response.body).to include("TEST NAME BOI")
        expect(response.body).to include("012345")
        expect(response.body).to include("test@testscheme.com")
        expect(response.body).to include("Quidos")
        expect(response.body).to include("SPEC000000")
        expect(response.body).to include("01225 667 570")
        expect(response.body).to include("info@quidos.co.uk")
      end

      it "shows the assessment details" do
        expect(response.body).to include(">About this assessment</h3>")
        expect(response.body).to include("4 January 2020")
        expect(response.body).to include("5 January 2020")
        expect(response.body).to include("Joe Bloggs Ltd")
        expect(response.body).to include(
          "Lloyds House, 18 Lloyd Street, Manchester, M2 5WA",
        )
      end

      it "shows the corresponding related party disclosures" do
        related_party_disclosures = {
          "1": "The assessor is not related to the owner of the property",
          "2": "The assessor is a relative of the property owner",
          "3":
            "The assessor is a relative of the professional dealing with the property transaction.",
          "4":
            "The assessor has an indirect relation to the owner (for example, somebody in the assessor’s family might be employed by the property owner).",
          "5": "The assessor occupies the property.",
          "6":
            "The assessor is the owner or director of the organisation dealing with the property transaction.",
          "7":
            "The assessor is employed by the organisation dealing with the property transaction.",
          "8":
            "The assessor has declared a financial interest in the property.",
          "9": "The assessor is employed by the property owner.",
          "10":
            "The assessor is contracted by the owner to provide other energy assessment services.",
          "11":
            "The assessor is contracted by the owner to provide services other than energy assessment.",
          "12":
            "The assessor has a previous relation to the owner (for example, they might previously have been an employee or contractor).",
          "13":
            "The assessor has not indicated whether they have a relation to this property",
        }

        related_party_disclosures.each do |key, disclosure|
          FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                              "1234-5678-1234-5678-1234",
                                                            energy_efficiency_band:
                                                              "b",
                                                            related_rrn:
                                                              "4192-1535-8427-8844-6702",
                                                            related_party_disclosure:
                                                              key

          response = get "/energy-certificate/1234-5678-1234-5678-1234"

          expect(response.body).to include(disclosure)
        end
      end

      it "shows the link to the Recommendation Report" do
        expect(response.body).to include(">Recommendation report</h2>")
        expect(response.body).to include(
          "/energy-certificate/4192-1535-8427-8844-6702",
        )
      end

      it "shows the other certificates section" do
        expect(response.body).to include("Other certificates for this property")
      end
    end

    describe "viewing the report contents section" do
      it "shows the report contents title" do
        expect(response.body).to include(">Certificate contents</h2>")
      end

      it "shows the section links" do
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#renting">Rules on letting this property</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#energy_rating_section">Energy rating and score</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#how_this_building_compares">How this property compares to others</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#energy_performance_breakdown">Breakdown of this property’s energy performance</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#related_report">Recommendation report</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#contact">Who to contact about this certificate</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a class="govuk-link" href="#other_certificates_and_reports">Other certificates for this property</a></p>',
        )
      end

      it "can navigate to each section" do
        expect(response.body).to include('id="renting"')
        expect(response.body).to include('id="energy_rating_section"')
        expect(response.body).to include('id="how_this_building_compares"')
        expect(response.body).to include('id="energy_performance_breakdown"')
        expect(response.body).to include('id="related_report"')
        expect(response.body).to include('id="contact"')
        expect(response.body).to include('id="other_certificates_and_reports"')
      end
    end

    it "shows the Other EPCs for this property section" do
      expect(response.body).to have_css "h2",
                                        text: "Other certificates for this property"
      expect(response.body).to have_css "p",
                                        text:
                                          "If you are aware of previous certificates for this property and they are not listed here, please contact us at mhclg.digital-services@communities.gov.uk or call our helpdesk on 020 3829 0748 (Monday to Friday, 9am to 5pm)."
      expect(response.body).to have_css "dt", text: "Certificate number"
      expect(response.body).to have_link "0000-0000-0000-0000-0001",
                                         href: "/energy-certificate/0000-0000-0000-0000-0001"
      expect(response.body).to have_css "dt", text: "Valid until"
      expect(response.body).to have_css "dd", text: "4 May 2026"
      expect(response.body).not_to have_link "0000-0000-0000-0000-0002",
                                             href: "/energy-certificate/0000-0000-0000-0000-0002"
      expect(response.body).not_to have_css "dd", text: "4 May 2019 (Expired)"
    end

    context "when there are no related assessments" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                            "1234-5678-1234-5678-1234",
                                                          energy_efficiency_band:
                                                            "b",
                                                          related_rrn:
                                                            "4192-1535-8427-8844-6702",
                                                          related_assessments: []
      end

      it "shows the related assessments section title" do
        expect(response.body).to have_css "h2",
                                          text: "Other certificates for this property"
      end

      it "shows the no related assessments content" do
        expect(response.body).to have_css "p",
                                          text: "There are no related certificates for this property."
      end

      it "does not show the superseded warning message" do
        expect(response.body).not_to have_css("div.govuk-warning-text", text: " A new certificate has replaced this one. See the new certificate")
      end
    end
  end

  context "when the assessment is fetched in Welsh" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                          "1234-5678-1234-5678-1234",
                                                        energy_efficiency_band:
                                                          "b"
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

  context "when the assessment exists without primary energy value" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                          "1234-5678-1234-5678-1234",
                                                        energy_efficiency_band:
                                                          "b",
                                                        primary_energy_use: nil
    end

    it "hides the primary energy use explanation" do
      expect(response.body).not_to include("About primary energy use")
    end
  end

  context "when a non domestic certificate is both NI and opted out" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc assessment_id:
                                                          "1234-5678-1234-5678-1234",
                                                        energy_efficiency_band:
                                                          "b",
                                                        postcode: "BT1 1AA",
                                                        opt_out: true
    end

    it "removes assessor contact details" do
      expect(response.body).to include(
        ">Who to contact about this certificate</h2>",
      )
      expect(response.body).not_to include(">Contacting the assessor</h3>")
      expect(response.body).not_to include("TEST NAME BOI")
      expect(response.body).not_to include("012345")
      expect(response.body).not_to include("test@testscheme.com")
      expect(response.body).to include("Quidos")
      expect(response.body).to include("SPEC000000")
      expect(response.body).to include("01225 667 570")
      expect(response.body).to include("info@quidos.co.uk")
      expect(response.body).to include(">About this assessment</h3>")
      expect(response.body).to include("4 January 2020")
      expect(response.body).to include("5 January 2020")
      expect(response.body).not_to include("Joe Bloggs Ltd")
      expect(response.body).not_to include(
        "Lloyds House, 18 Lloyd Street, Manchester, M2 5WA",
      )
    end
  end

  context "when the certificate has been superseded" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc(
        assessment_id: "1234-5678-1234-5678-1234",
        energy_efficiency_band:
          "b",
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "shows the superseded warning message" do
      expect(response.body).to have_css("div.govuk-warning-text", text: /Warning/)
      expect(response.body).to have_css("div.govuk-warning-text", text: /A new certificate has replaced this one/)
    end

    it "the warning is hidden for print using the existing css definition" do
      expect(response.body).to include('<div class="govuk-warning-text"')
    end

    it "shows the superseded link" do
      expect(response.body).to have_link("See the new certificate", href: "/energy-certificate/0000-0000-0000-0000-0001")
    end
  end

  context "when the certificate has expired" do
    before do
      FetchAssessmentSummary::AssessmentStub.fetch_cepc(
        assessment_id: "1234-5678-1234-5678-1234",
        expiry_date: "2010-01-05",
        energy_efficiency_band: "b",
        superseded_by: nil,
      )
    end

    let(:response) { get "/energy-certificate/1234-5678-1234-5678-1234" }

    it "shows the expired on message in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box label", text: "This certificate expired on")
    end

    it "shows the expired date in the epc blue box" do
      expect(response.body).to have_css(".epc-extra-box p", text: "5 January 2010")
    end

    it "shows an expired warning message" do
      expect(response.body).to have_css(".govuk-warning-text", text: "This certificate has expired.")
    end

    it "shows a link to get the get service within the warning message" do
      expect(response.body).to have_css(".govuk-warning-text a")
      expect(response.body).to have_link("get a new certificate", href: "http://getting-new-energy-certificate.local.gov.uk:9393/")
    end

    context "when the expired epc has been superseded" do
      before do
        FetchAssessmentSummary::AssessmentStub.fetch_cepc(
          assessment_id: "1234-5678-1234-5678-1234",
          expiry_date: "2010-01-05",
          energy_efficiency_band: "b",
        )
      end

      it "shows an superseded warning message" do
        expect(response.body).to have_css(".govuk-warning-text", text: "A new certificate has replaced this one")
      end

      it "does not show an expired warning message" do
        expect(response.body).not_to have_css(".govuk-warning-text", text: "This certificate has expired")
      end
    end
  end
end
