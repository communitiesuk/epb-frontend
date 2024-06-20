describe "Acceptance::ServicePerformance", type: :feature do
  include RSpecFrontendServiceMixin

  describe "get . find-energy-certificate/service-performance" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance"
    end

    before do
      ServicePerformance::CountryStatsStub.statistics
    end

    it "has the correct title" do
      expect(response.body).to include("<title>Check how this service is performing – GOV.UK</title>")
    end

    it "has the correct H1" do
      expect(response.body).to have_css("h1", text: "Check how this service is performing")
    end

    it "has the correct intro text" do
      expect(response.body).to have_css("div", text: "Use this page to find data on:")
      expect(response.body).to have_css("ul.govuk-list li", text: "the number of energy certificates uploaded to the Energy Performance of Buildings Register")
      expect(response.body).to have_css("ul.govuk-list li", text: "the average energy rating for domestic and non-domestic properties")
      expect(response.body).to have_css("div", text: "This data covers England and Wales, and Northern Ireland.")
      expect(response.body).to have_css("div", text: "Updated: monthly")
    end

    it "has a header for each type of assessment" do
      expect(response.body).to have_css("h2", text: "Domestic data – new building (SAP)")
      expect(response.body).to have_css("h2", text: "Domestic data – existing building (RdSAP)")
      expect(response.body).to have_css("h2", text: "Non-domestic data – commercial energy performance certificate (CEPC)")
      expect(response.body).to have_css("h2", text: "Non-domestic data – display energy certificate (DEC)")
      expect(response.body).to have_css("h2", text: "Non-domestic data – display energy certificate recommendation report (DEC-RR)")
      expect(response.body).to have_css("h2", text: "Non-domestic data – air conditioning inspection certificate (AC-CERT)")
    end

    it "has an accordion for each type of assessment" do
      expect(response.body).to have_css("div.govuk-accordion", count: 6)
      expect(response.body).to have_css("#accordion-sap")
      expect(response.body).to have_css("#accordion-rdsap")
      expect(response.body).to have_css("#accordion-cepc")
      expect(response.body).to have_css("#accordion-dec")
      expect(response.body).to have_css("#accordion-dec-rr")
      expect(response.body).to have_css("#accordion-dec-rr")
      expect(response.body).to have_css("#accordion-ac-cert")
    end

    it "has hidden text on the accordion headings for screen readers" do
      expect(response.body).to have_css("span", text: "SAP certificates uploaded in ")
    end

    it "the assessment tables have all the relevant cells" do
      flattened_regions_data = ServicePerformance::CountryStatsStub.body[:data][:assessments].flatten(2).reject { |e| e.is_a?(Symbol) }
      flattened_regions_data.each do |row|
        expect(response.body).to have_css("table.govuk-table tr>th.month-year", text: Date.parse("#{row[:month]}-01").strftime("%b %Y"))
        expect(response.body).to have_css("table.govuk-table tr>td.num-assessments", text: row[:numAssessments].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse)
      end
    end

    it "has a table for SAP that does have a column for average rating" do
      expect(response.body).to have_css("tr>td.rating-average")
    end

    it "has a table for DEC, AC-CERT that does not have a column for average rating" do
      expect(response.body).not_to have_css("#ac-cert.table.govuk-table tr>td.rating-average")
      expect(response.body).not_to have_css("#dec.table.govuk-table tr>td.rating-average")
      expect(response.body).not_to have_css("#dec-rr.table.govuk-table tr>td.rating-average")
    end

    it "the table has the expected th text" do
      expect(response.body).to have_css("table.govuk-table th.month", text: "Month")
      expect(response.body).to have_css("table.govuk-table th.number-uploaded", text: "Certificates uploaded")
      expect(response.body).to have_css("table.govuk-table th.average-energy-rating", text: "Average energy rating")
    end

    it "has the correct download links for each region" do
      expect(response.body).to have_link("Download a copy of the data for all regions", href: "service-performance/download-csv?country=all")
      expect(response.body).to have_link("Download a copy of the data for England", href: "service-performance/download-csv?country=england")
      expect(response.body).to have_link("Download a copy of the data for Northern Ireland", href: "service-performance/download-csv?country=northern-ireland")
      expect(response.body).to have_link("Download a copy of the data for Wales", href: "service-performance/download-csv?country=wales")
      expect(response.body).to have_link("Download a copy of the data for Other", href: "service-performance/download-csv?country=other")
    end

    it "ensure all ids are unique" do
      div_ids = Capybara.string(response.body).all("div").map { |d| d["id"] }.compact
      div_ids.each do |id|
        expect(response.body).to have_css("div##{id}", count: 1)
      end
    end
  end

  describe "get . find-energy-certificate/service-performance?lang=cy " do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance?lang=cy"
    end

    before do
      ServicePerformance::CountryStatsStub.statistics
    end

    it "has the correct Welsh title" do
      expect(response.body).to include("<title>Gwirio sut mae’r gwasanaeth hwn yn perfformio – GOV.UK</title>")
    end

    it "has the correct Welsh H1" do
      expect(response.body).to have_css("h1", text: "Gwirio sut mae’r gwasanaeth hwn yn perfformio")
    end
  end
end
