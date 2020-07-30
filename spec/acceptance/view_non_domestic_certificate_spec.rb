# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificate" do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/1234-5678-1234-5678-1234"
  end

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
      FetchAssessmentSummary::AssessmentStub.fetch("1234-5678-1234-5678-1234", "b")
    end

    it "returns status 200" do
      expect(response.status).to eq 200
    end

    it "shows the non-domestic energy performance certificate title" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Non-domestic Energy Performance Certificate</h1>',
      )
    end

    context "when viewing the non-domestic EPC box section" do
      it "shows the address summary" do
        expect(response.body).to include(
          '<p class="epc-address govuk-body">Flat 33<br>2 Marsham Street<br>London<br>SW1B 2BB</p>',
        )
      end

      it "shows the energy rating title" do
        expect(response.body).to include(
          '<p class="epc-rating-title govuk-body">Energy Rating</p>',
        )
      end

      it "shows the current energy energy efficiency band" do
        expect(response.body).to include(
          '<p class="epc-rating-result govuk-body">B</p>',
        )
      end

      it "shows the date of expiry" do
        expect(response.body).to include(
          '<p class="govuk-body epc-extra-box">Valid until 5 January 2030</p>',
        )
      end

      it "shows the certificate number label" do
        expect(response.body).to include("<label>Certificate Number</label>")
      end

      it "shows the certificate number" do
        expect(response.body).to include("<b>1234-5678-1234-5678-1234</b>")
      end
    end

    context "when viewing the Rules on letting this property section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Rules on letting this property</h2>',
        )
      end

      it "shows the letting info text" do
        expect(response.body).to include(
          '<p class="govuk-body">Properties can be let if they have an energy rating of A+ to E.</p>',
        )

        expect(response.body).to include(
          '<p class="govuk-body">If a property has an energy rating of F or G, the landlord cannot grant a tenancy to new or existing tenants, unless an exemption has been registered.</p>',
        )

        expect(response.body).to include(
          '<p class="govuk-body">From 1 April 2023, landlords will not be allowed to continue letting a non-domestic property on an existing lease if that property has an energy rating of F or G.</p>',
        )
      end

      it "shows the guidance for landlords link" do
        expect(response.body).to include(
          '<p class="govuk-body">You can read <a href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/824018/Non-Dom_Private_Rented_Property_Minimum_Standard_-_Landlord_Guidance.pdf">guidance for landlords on the regulations and exemptions</a>.</p>',
        )
      end

      context "with an energy rating of F/G" do
        before do
          FetchAssessmentSummary::AssessmentStub.fetch("1234-5678-1234-5678-1234", "g")
        end

        it "shows the letting info warning text" do
          expect(response.body).to include(
            '<strong class="govuk-warning-text__text"><span class="govuk-warning-text__assistive">Warning</span>You may not be able to let this property.</strong>',
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
            '<p class="govuk-body">You can read <a href="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/824018/Non-Dom_Private_Rented_Property_Minimum_Standard_-_Landlord_Guidance.pdf">guidance for landlords on the regulations and exemptions</a>.</p>',
          )
        end

        it "shows the recommendation text" do
          expect(response.body).to include(
            '<p class="govuk-body">Properties can be let if they have an energy rating of A+ to E. The <a href="#">recommendation report</a> sets out changes you can make to improve the property’s rating.</p>',
          )
        end
      end
    end

    context "when viewing the Energy efficiency rating for this building section" do
      it "shows the section heading" do
        expect(response.body).to include(
          '<h2 class="govuk-heading-l">Energy efficiency rating for this building</h2>',
        )
      end

      it "shows the current energy rating text" do
        expect(response.body).to include(
          '<p class="govuk-body">This building’s current energy rating is B.</p>',
        )
      end

      it "shows the SVG title" do
        expect(response.body).to include(
          '<title id="svg-title">This building’s energy rating is B (35)</title>',
        )
      end

      it "shows the net zero carbon emissions text" do
        expect(response.body).to include(
          '<text x="420" y="65" class="small">Net zero CO₂</text>',
        )
      end

      it "shows the SVG with energy ratings" do
        expect(response.body).to include('<svg width="615" height="426"')
      end

      it "shows the SVG with energy rating band numbers" do
        expect(response.body).to include('<tspan x="8" y="105">0-25</tspan>')
      end

      it "shows the energy rating description" do
        expect(response.body).to include(
          '<p class="govuk-body govuk-!-margin-top-3">Buildings are given a rating from A+ (most efficient) to G (least efficient).</p>',
        )
      end

      it "shows the energy rating score description" do
        expect(response.body).to include(
          '<p class="govuk-body">Buildings are also given a score. The larger the number, the more expensive your fuel bills are likely to be.</p>',
        )
      end
    end
  end
end
