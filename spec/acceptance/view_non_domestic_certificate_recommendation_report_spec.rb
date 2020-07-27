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
      FetchCertificate::RecommendationReportStub.fetch assessment_id:
                                                         "1234-5678-1234-5678-1234"
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

      it "shows the report contents title" do
        expect(response.body).to include(">Report Contents</h3>")
      end

      it "shows the print this report text" do
        expect(response.body).to include(">Print this report</a>")
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
          'For more information, see the <a href="#">Energy Performance Certificate for this report</a>',
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

      describe "three year changes subsection" do
        it "shows the three year changes caption" do
          expect(response.body).to include(
            "Changes that pay for themselves within 3 years",
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
    end
  end
end
