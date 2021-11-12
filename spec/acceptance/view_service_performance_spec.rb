describe "Acceptance::ServicePerformance", type: :feature do
  include RSpecFrontendServiceMixin

  describe "get . find-energy-certificate/service-performance" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance"
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

    it "has a table for the data set" do
      expect(response.body).to have_table
      expect(response.body).to have_selector(".govuk-table")
      expect(response.body).to have_selector("caption", text: "Monthly assessments stat")
    end

    it "the table has the correct number of rows : n th(1) + n stub(17)" do
      expect(response.body).to have_css("table.govuk-table tr", count: 18)
    end

    it "the table writes the body into all the relevant columns" do
      ServicePerformance::Stub.body[:data].each do |row|
        expect(response.body).to have_css("table.govuk-table tr>td.month-year", text: row[:monthYear].to_s)
        expect(response.body).to have_css("table.govuk-table tr>td.assessment-type", text: row[:assessmentType].to_s)
        expect(response.body).to have_css("table.govuk-table tr>td.num-assessments", text: row[:numAssessments].to_s)
        expect(response.body).to have_css("table.govuk-table tr>td.rating-average", text: row[:ratingAverage].round(2).to_s)
      end
    end
  end
end
