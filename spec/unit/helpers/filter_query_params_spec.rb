describe "Helpers.filter_query_params", type: :helper do
  subject(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "when URL contains no query string" do
    it "leaves the passed in URL unaffected" do
      url = "https://domain.com/fragment"
      expect(frontend_service_helpers.filter_query_params(url, :removed)).to eq url
    end
  end

  context "when URL contains a query string with a query param being filtered and no other params" do
    it "removes the query string from the URL" do
      expect(frontend_service_helpers.filter_query_params("https://domain.com/fragment?param=true", :param)).to eq "https://domain.com/fragment"
    end
  end

  context "when URL contains a query string with a query param being filtered at the start and one more param" do
    it "removes the correct query param from the query string" do
      expect(frontend_service_helpers.filter_query_params("https://domain.com/fragment?remove=true&keep=true", :remove)).to eq "https://domain.com/fragment?keep=true"
    end
  end

  context "when URL contains a query string with multiple query params being filtered" do
    it "removes the filtered query params from the query string" do
      expect(frontend_service_helpers.filter_query_params("https://domain.com/fragment?remove=true&keep=true&delete=1", :remove, :delete)).to eq "https://domain.com/fragment?keep=true"
    end
  end

  context "when URL contains non-ASCII" do
    it "just removes query parameters as fallback" do
      expect(frontend_service_helpers.filter_query_params("https://domain.com/energy-certificate/8531-6920-6699-5122-7906?print=true&_sm_au_=iVVsLpFrZJ6fRpnHFcVTvKQkc\xE2\x80\xA6", :print)).to eq "https://domain.com/energy-certificate/8531-6920-6699-5122-7906"
    end
  end
end
