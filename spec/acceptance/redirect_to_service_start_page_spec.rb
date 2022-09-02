RSpec.describe "Redirect to service start page" do
  include RSpecFrontendServiceMixin

  let(:host_name) { "http://find-an-energy-certificate.local.gov.uk" }

  paths = FrontendService.routes["GET"].map { |route| route.first.to_s } - %w[/]

  directly_accessible_paths = %w[
    /healthcheck
    /energy-certificate/:assessment_id
    /energy-certificate/:assessment_id/dec_summary
    /accessibility-statement
    /cookies
    /service-performance
    /service-performance/download-csv
  ].freeze

  context "when testing redirecting" do
    before do
      stub_const("ENV", { "STAGE" => "redirect-test" })
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(assessment_id: "0000-0000-0000-0000-0001")
      FetchAssessmentSummary::AssessmentStub.fetch_dec_summary(assessment_id: "0000-0000-0000-0000-0001")
      ServicePerformance::CountryStatsStub.statistics
    end

    directly_accessible_paths.each do |path|
      it "returns status 200 for #{path} (page accessible directly) regardless of the referrer" do
        path.sub!(":assessment_id", "0000-0000-0000-0000-0001") if path.include?(":assessment_id")
        response = get host_name + path

        expect(response.status).to eq(200)
      end
    end

    (paths - directly_accessible_paths).each do |path|
      it "returns status 303 for #{path} when a referrer is nil" do
        response = get host_name + path

        expect(response.status).to eq(303)
      end
    end

    it "returns status 303 when a referrer is outside of the service" do
      env "HTTP_REFERER", "http://example.com"
      response = get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/type-of-property"

      expect(response.status).to eq(303)
    end

    it "returns status 200 when a referrer is GOV.UK start page" do
      env "HTTP_REFERER", "https://www.gov.uk/find-energy-certificate"
      response = get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/type-of-property"

      expect(response.status).to eq(200)
    end

    it "returns status 200 when a referrer is withing the services" do
      env "HTTP_REFERER", "https://getting-new-energy-certificate.service.gov.uk/find-an-assessor/type-of-domestic-property"
      response = get "http://getting-new-energy-certificate.local.gov.uk/find-an-assessor/type-of-property"

      expect(response.status).to eq(200)
    end

    it "returns status 200 for a search results page with 1 param" do
      FindAssessor::ByPostcode::Stub.search_by_postcode(
        "SW1A 2AA",
        "nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5",
      )

      response = get "http://getting-new-energy-certificate.local.gov.uk/find-a-non-domestic-assessor/search-by-postcode?postcode=SW1A+2AA"
      expect(response.status).to eq(200)
    end

    it "returns status 200 for a search results page with 2 params" do
      FindCertificate::Stub.search_by_street_name_and_town_one_result(
        "1 Makeup Street",
        "Beauty Town",
        %w[AC-CERT AC-REPORT DEC DEC-RR CEPC CEPC-RR],
        "CEPC",
      )

      response = get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=1%20Makeup%20Street&town=Beauty%20Town"
      expect(response.status).to eq(200)
    end

    it "returns status 200 for a search results page with 2 params and lang param" do
      FindCertificate::Stub.search_by_street_name_and_town_one_result(
        "1 Makeup Street",
        "Beauty Town",
        %w[AC-CERT AC-REPORT DEC DEC-RR CEPC CEPC-RR],
        "CEPC",
      )

      response = get "http://find-energy-certificate.local.gov.uk/find-a-non-domestic-certificate/search-by-street-name-and-town?street_name=1%20Makeup%20Street&town=Beauty%20Town&lang=cy"

      expect(response.status).to eq(200)
    end
  end
end
