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
      expect(response.body).to include("<title>Check how this service is performing</title>")
    end

    it "has the correct H1" do
      expect(response.body).to have_css("h1", text: "Check how this service is performing")
    end

    it "has the intro text" do
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
      expect(response.body).to have_css("h2", text: "Non-domestic data – air conditioning reports (AC-CERT)")
    end

    it "has an accordion for each type of assessment" do
      expect(response.body).to have_css("div.govuk-accordion", count: 6)
      expect(response.body).to have_css("#accordion-sap")
      expect(response.body).to have_css("#accordion-rdsap")
      expect(response.body).to have_css("#accordion-cepc")
      expect(response.body).to have_css("#accordion-dec")
      expect(response.body).to have_css("#accordion-dec-rr")
      expect(response.body).to have_css("#accordion-ac-cert")
    end

    it "has a table for each region (all, England and Wales, Northern Ireland) and customer satisfaction" do
      expect(response.body).to have_css("table", count: 19)
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
      expect(response.body).to have_css("table.govuk-table th.number-uploaded", text: "Number uploaded")
      expect(response.body).to have_css("table.govuk-table th.average-energy-rating", text: "Average energy rating")
    end

    it "has the correct download links for each region" do
      expect(response.body).to have_link("Download a copy of the data for all regions", href: "service-performance/download-csv?country=all")
      expect(response.body).to have_link("Download a copy of the data for England and Wales", href: "service-performance/download-csv?country=england-wales")
      expect(response.body).to have_link("Download a copy of the data for Northern Ireland", href: "service-performance/download-csv?country=northern-ireland")
    end

    it "has the data inside a GDS tab component" do
      expect(response.body).to have_css("div.govuk-tabs")
    end

    it "has a tab has 2 headers" do
      expect(response.body).to have_css("div.govuk-tabs li", count: 2)
      expect(response.body).to have_link("Energy certificates uploaded", href: "#epc-tab")
      expect(response.body).to have_link("Customer satisfaction", href: "#customer-satisfaction-tab")
    end

    it "has the epc data inside the correct tab" do
      expect(response.body).to have_css("div.govuk-tabs div#epc-tab")
      expect(response.body).to have_css("div.govuk-tabs div#customer-satisfaction-tab")
    end

    it "has the epc tab as NOT hidden" do
      expect(response.body).to have_css("div.govuk-tabs div#epc-tab[class=\"govuk-tabs__panel\"]")
    end

    it "has the customer-satisfaction tab as hidden" do
      expect(response.body).to have_css("div.govuk-tabs div#customer-satisfaction-tab[class=\"govuk-tabs__panel govuk-tabs__panel--hidden\"]")
    end

    it "has the customer satisfaction table inside the correct tab" do
      expect(response.body).to have_css("div#customer-satisfaction-tab > div#customer-satisfaction > table")
    end

    it "has a customer satisfaction table with the correct headers" do
      expect(response.body).to have_css("div#customer-satisfaction > table > thead > tr > th.month", text: "Month")
      expect(response.body).to have_css("div#customer-satisfaction > table > thead > tr > th.very-satisfied", text: "Very satisfied")
      expect(response.body).to have_css("div#customer-satisfaction > table > thead > tr > th.satisfied", text: "Satisfied")
      expect(response.body).to have_css("div#customer-satisfaction > table > thead > tr > th.neither", text: "Neither satisfied nor dissatisfied")
      expect(response.body).to have_css("div#customer-satisfaction > table > thead > tr > th.dissatisfied", text: "Dissatisfied")
      expect(response.body).to have_css("div#customer-satisfaction > table > thead > tr > th.very-dissatisfied", text: "Very dissatisfied")
    end

    it "the customer table has all the relevant cells" do
      ServicePerformance::CountryStatsStub.body[:data][:customer].each do |row|
        expect(response.body).to have_css("div#customer-satisfaction > table tr>th.month-year", text: Date.parse("#{row['month']}-01").strftime("%b %Y"))
        expect(response.body).to have_css("div#customer-satisfaction > table tr>td.satisfied", text: row["satisfied"])
      end
    end
  end
end
