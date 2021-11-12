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

    # it "each table has the expected caption" do
    #   grouped_data.keys.each {| key |
    #     expect(response.body).to have_css("div##{key.downcase}.govuk-table caption", text: "Monthly Assessments Stats #{key}")
    #   }
    #
    # end

    it "the tables have all the relevant cells" do
      ServicePerformance::Stub.body[:data].each do |row|
        expect(response.body).to have_css("table.govuk-table tr>td.month-year", text: row[:month].to_s)
        expect(response.body).to have_css("table.govuk-table tr>td.num-assessments", text: row[:numAssessments].to_s)
        expect(response.body).to have_css("table.govuk-table tr>td.rating-average", text: row[:ratingAverage].round(2).to_s)
      end
    end
  end
end
