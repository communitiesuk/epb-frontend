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
  end
end
