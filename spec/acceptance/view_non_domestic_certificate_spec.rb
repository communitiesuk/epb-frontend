# frozen_string_literal: true

describe "Acceptance::NonDomesticEnergyPerformanceCertificate" do
  include RSpecFrontendServiceMixin

  context "when the assessment exists" do
    before { FetchCertificate::NonDomesticStub.fetch assessment_id: "123-456" }

    let(:response) { get "/energy-performance-certificate/123-456" }

    it "returns status 200" do
      expect(response.status).to eq(200)
    end

    it "shows the non-domestic energy performance certificate title" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Non-domestic Energy Performance Certificate</h1>',
      )
    end

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
      expect(response.body).to include("<b>123-456</b>")
    end
  end
end
