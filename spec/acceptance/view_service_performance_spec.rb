describe "Acceptance::ServicePerformance", type: :feature do
  include RSpecFrontendServiceMixin

  describe "get . find-energy-certificate/service-performance" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance"
    end

    let(:grouped_data) do
      ServicePerformance::Stub.body[:data].group_by { |h| h[:assessmentType] }
    end

    before do
      ServicePerformance::Stub.statistics
    end

    it "has the correct title" do
      expect(response.body).to include("<title>Service Performance</title>")
    end

    it "has the correct H1" do
      expect(response.body).to have_css("h1", text: "Service Performance")
    end

    it "has a table for each type of assessment" do
      number_epcs = grouped_data.keys.length
      expect(response.body).to have_css("table.govuk-table", count: number_epcs)
    end

    it "each table has the expected caption" do
      grouped_data.each_key do |key|
        expect(response.body).to have_css("##{key.downcase} caption", text: "Monthly Assessments Stats #{key}")
      end
    end

    it "the tables have all the relevant cells" do
      ServicePerformance::Stub.body[:data].each do |row|
        expect(response.body).to have_css("table.govuk-table tr>th.month-year", text: Date.parse("#{row[:month]}-01").strftime("%B %Y"))
        expect(response.body).to have_css("table.govuk-table tr>td.num-assessments", text: row[:numAssessments].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse)
      end
    end

    it "has a table for SAP that does have  a column for average rating" do
      expect(response.body).to have_css("tr>td.rating-average")
    end

    it "has a table for DEC, AC-CERT that does not have a column for average rating" do
      expect(response.body).not_to have_css("#ac-cert.table.govuk-table tr>td.rating-average")
      expect(response.body).not_to have_css("#dec.table.govuk-table tr>td.rating-average")
      expect(response.body).not_to have_css("#dec-rr.table.govuk-table tr>td.rating-average")
    end
  end
end
