describe "cookies page", type: :feature do
  include RSpecFrontendServiceMixin

  describe ".get getting-new-energy-certificate/cookies" do
    context "when cookies page rendered" do
      let(:response) do
        get "http://getting-new-energy-certificate.local.gov.uk/cookies"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the cookies page heading" do
        expect(response.body).to include("Cookies on our service")
      end

      it "displays the cookies page contents" do
        expect(response.body).to include(
          "Cookies are files saved on your phone, tablet or computer when you visit a website.",
        )
      end
    end
  end

  describe ".get find-energy-certificate/cookies" do
    context "when cookies page rendered" do
      let(:response) do
        get "http://find-energy-certificate.local.gov.uk/cookies"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the cookies page heading" do
        expect(response.body).to include("Cookies on our service")
      end

      it "displays the cookies contents" do
        expect(response.body).to include(
          "Cookies that measure website use",
        )
      end
    end
  end
end
