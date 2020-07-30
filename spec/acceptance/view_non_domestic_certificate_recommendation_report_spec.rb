# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificateRecommendationReport" do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/1234-5678-1234-5678-1234"
  end

  context "when the assessment does not exist" do
    before do
      FetchCertificate::NoAssessmentStub.fetch("1234-5678-1234-5678-1234")
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
      FetchCertificate::NonDomesticStub.fetch assessment_id:
                                                "1234-5678-1234-5678-0000"

      FetchCertificate::RecommendationReportStub.fetch assessment_id:
                                                         "1234-5678-1234-5678-1234",
                                                       linked_to_cepc:
                                                         "1234-5678-1234-5678-0000"
    end

    it "returns status 200" do
      expect(response.status).to eq 200
    end

    it "shows the non-domestic energy performance certificate title" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Non-domestic Energy Performance Certificate Recommendation Report</h1>',
      )
    end

    describe "viewing the summary section" do
      it "shows the address" do
        expect(response.body).to include("Flat 33")
        expect(response.body).to include("2 Marsham Street")
        expect(response.body).to include("London")
        expect(response.body).to include("SW1B 2BB")
      end

      it "shows the date of expiry" do
        expect(response.body).to include("<label>Valid until</label>")
        expect(response.body).to include("<b>5 January 2030</b>")
      end

      it "shows the certificate number" do
        expect(response.body).to include("<label>Certificate number</label>")
        expect(response.body).to include("<b>1234-5678-1234-5678-1234</b>")
      end

      it "shows the print this report text" do
        expect(response.body).to include(">Print this report</a>")
      end
    end

    describe "viewing the report contents section" do
      it "shows the report contents title" do
        expect(response.body).to include(">Report Contents</h3>")
      end

      it "shows the section links" do
        expect(response.body).to include(
          '<p class="govuk-body"><a href="#rating">Energy rating and EPC</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a href="#recommendations">Recommendations</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a href="#property_details">Building and report details</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a href="#assessor_details">Assessor’s details</a></p>',
        )
        expect(response.body).to include(
          '<p class="govuk-body"><a href="#other_reports">Other reports for this property</a></p>',
        )
      end

      it "can navigate to each section" do
        expect(response.body).to include('id="rating"')
        expect(response.body).to include('id="recommendations"')
        expect(response.body).to include('id="property_details"')
        expect(response.body).to include('id="assessor_details"')
        expect(response.body).to include('id="other_reports"')
      end
    end

    describe "viewing the Energy rating and EPC section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Energy rating and EPC</h2>',
        )
      end

      it "shows the current energy rating text" do
        expect(response.body).to include(
          '<p class="govuk-body">This building’s current energy rating is B.</p>',
        )
      end

      it "shows the link to certificate for more information" do
        expect(response.body).to include(
          'For more information, see the <a href="/energy-performance-certificate/1234-5678-1234-5678-0000">Energy Performance Certificate for this report</a>',
        )
      end
    end

    describe "viewing the Recommendations section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Recommendations</h2>',
        )
      end

      it "shows the opportunities text" do
        expect(response.body).to include(
          '<p class="govuk-body">The assessment found opportunities to improve the building’s energy efficiency.</p>',
        )
      end

      it "shows the recommended improvements text" do
        expect(response.body).to include(
          '<p class="govuk-body">Recommended improvements are grouped by the estimated time it would take for the change to pay for itself. The assessor may also make additional recommendations.</p>',
        )
      end

      it "shows the description text" do
        expect(response.body).to include(
          '<p class="govuk-body">Each recommendation is marked as low, medium or high for the potential impact the change would have on reducing the building’s carbon emissions.</p>',
        )
      end

      it "shows the Recommendation table heading" do
        expect(response.body).to include(
          '<th scope="col" class="govuk-table__header govuk-!-width-three-quarters">Recommendation</th>',
        )
      end

      it "shows the Potential impact table heading" do
        expect(response.body).to include(
          '<th scope="col" class="govuk-table__header govuk-!-width-three-quarters">Potential impact</th>',
        )
      end

      describe "three year changes subsection" do
        it "shows the three year changes caption" do
          expect(response.body).to include(
            "Changes that pay for themselves within 3 years",
          )
        end

        it "shows the short payback recommendations" do
          expect(response.body).to include(
            '<th scope="row" class="govuk-table__header govuk-!-font-weight-regular">Consider replacing T8 lamps with retrofit T5 conversion kit.</th>',
          )
          expect(response.body).to include(
            '<td class="govuk-table__cell">HIGH</td>',
          )
          expect(response.body).to include(
            '<th scope="row" class="govuk-table__header govuk-!-font-weight-regular">Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.</th>',
          )
          expect(response.body).to include(
            '<td class="govuk-table__cell">LOW</td>',
          )
        end
      end

      describe "three to seven year changes subsection" do
        it "shows the three to seven year changes caption" do
          expect(response.body).to include(
            "Changes that pay for themselves within 3 to 7 years",
          )
        end

        it "shows the medium payback recommendations" do
          expect(response.body).to include(
            '<th scope="row" class="govuk-table__header govuk-!-font-weight-regular">Add optimum start/stop to the heating system.</th>',
          )
          expect(response.body).to include(
            '<td class="govuk-table__cell">MEDIUM</td>',
          )
        end
      end

      describe "more than seven year changes subsection" do
        it "shows the more than seven year changes caption" do
          expect(response.body).to include(
            "Changes that pay for themselves in more than 7 years",
          )
        end

        it "shows the long payback recommendations" do
          expect(response.body).to include(
            '<th scope="row" class="govuk-table__header govuk-!-font-weight-regular">Consider installing an air source heat pump.</th>',
          )
          expect(response.body).to include(
            '<td class="govuk-table__cell">HIGH</td>',
          )
        end
      end

      describe "additional recommendations subsection" do
        it "shows the subsection text" do
          expect(response.body).to include(
            "This table lists additional recommendations made by the assessor.",
          )
        end

        it "shows the additional recommendations caption" do
          expect(response.body).to include("Additional recommendations")
        end

        it "shows the other payback recommendations" do
          expect(response.body).to include(
            '<th scope="row" class="govuk-table__header govuk-!-font-weight-regular">Consider installing PV.</th>',
          )
          expect(response.body).to include(
            '<td class="govuk-table__cell">HIGH</td>',
          )
        end
      end
    end

    describe "viewing the Building and report details section" do
      it "shows the section heading" do
        expect(response.body).to include("Building and report details")
      end

      it "shows the date of assessment" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Report issued on</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">2 January 2020</dd>',
        )
      end

      it "shows the total useful floor area" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Total useful floor area</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">935 square metres</dd>',
        )
      end

      it "shows the building environment" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Building environment</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">Heating and Natural Ventilation</dd>',
        )
      end

      it "shows the calculation tool" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Calculation tool</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">CLG, iSBEM, v5.4.b, SBEM, v5.4.b.0</dd>',
        )
      end
    end

    describe "viewing the Assessor's details section" do
      it "shows the section heading" do
        expect(response.body).to include("Assessor’s details")
      end

      it "shows the name of the assessor" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Assessor’s name</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">John T Howard</dd>',
        )
      end

      it "shows the name of the employer" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Employer’s name</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">Viridian Consulting Engineers Ltd</dd>',
        )
      end

      it "shows the address of the employer" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Employer’s address</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">Lloyds House, 18 Lloyd Street, Manchester, M2 5WA</dd>',
        )
      end

      it "shows the assessor number" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Assessor number</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">TEST000000</dd>',
        )
      end

      it "shows the accreditation scheme" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Accreditation scheme</dt>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value">TEST Ltd</dd>',
        )
      end

      it "shows the declaration" do
        expect(response.body).to include(
          '<dt class="govuk-summary-list__key govuk-!-width-one-half">Assessor’s declaration</dt>',
        )
        expect(response.body).to include(
          '<span class="govuk-details__summary-text">No connection to the property</span>',
        )
        expect(response.body).to include(
          '<div class="govuk-details__text">The assessor declared they have no personal or business connection with the property’s owner or anyone who may have an interest in the property.</div>',
        )
      end
    end

    describe "viewing the Other reports for this property section" do
      it "shows the section heading" do
        expect(response.body).to include("Other reports for this property")
      end

      it "shows the non-listed assessments reminder" do
        expect(response.body).to include(
          '<p class="govuk-body">If you are aware of previous reports for this property and they are not listed here, please contact the Help Desk at 01632 164 6672.</p>',
        )
      end

      it "shows the first related assessment" do
        expect(response.body).to include(
          '<a href="/energy-performance-certificate/8411-8264-4325-3608-3503">8411-8264-4325-3608-3503</a>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value govuk-!-width-one-half">Energy performance certificate<br />',
        )
        expect(response.body).to include("<b>Valid until 4 May 2030</b>")
      end

      it "shows the third related assessment" do
        expect(response.body).to include(
          '<a href="/energy-performance-certificate/3411-8465-4422-3628-3503">3411-8465-4422-3628-3503</a>',
        )
        expect(response.body).to include(
          '<dd class="govuk-summary-list__value govuk-!-width-one-half">Commercial energy performance certificate recommendation report<br />',
        )
        expect(response.body).to include(
          '<b class="expired-text">4 May 2010 (Expired)</b>',
        )
      end

      context "when the assessment does not have a related EPC" do
        before do
          FetchCertificate::RecommendationReportStub.fetch assessment_id:
                                                               "1234-5678-1234-5678-1234"
        end

        it "returns status 200" do
          expect(response.status).to eq 200
        end

        it "does not show the Energy rating and EPC section heading" do
          expect(response.body).not_to include(
                                           '<h2 class="govuk-heading-l">Energy rating and EPC</h2>',
                                           )
        end
      end
    end
  end
end
