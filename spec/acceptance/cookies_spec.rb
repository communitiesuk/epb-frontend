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

  describe ".post find-energy-certificate/cookies" do
    context "when cookie options are submitted opting out" do
      let(:response) do
        post "http://find-energy-certificate.local.gov.uk/cookies", { cookies_setting: "false" }
      end

      it "returns status 302" do
        expect(response.status).to eq(302)
      end

      it "sets the cookie_consent cookie to false" do
        expect(response.cookies["cookie_consent"].first).to eq("false")
      end
    end

    context "when cookie options are submitted opting in" do
      let(:response) do
        post "http://find-energy-certificate.local.gov.uk/cookies", { cookies_setting: "true" }
      end

      it "returns status 302" do
        expect(response.status).to eq(302)
      end

      it "sets the cookie_consent cookie to true" do
        expect(response.cookies["cookie_consent"].first).to eq("true")
      end
    end

    context "when no values are submitted" do
      let(:response) do
        post "http://find-energy-certificate.local.gov.uk/cookies", { cookies_setting: nil }
      end

      it "returns status 302" do
        expect(response.status).to eq(302)
      end

      it "sets the cookie_consent cookie to true" do
        expect(response.cookies["cookie_consent"].first).to eq("true")
      end
    end

    context "when someone hijacks the cookie_setting values and submits" do
      let(:response) do
        post "http://find-energy-certificate.local.gov.uk/cookies", { cookies_setting: "potentiallydodgyvalue" }
      end

      it "returns status 302" do
        expect(response.status).to eq(302)
      end

      it "sets the cookie_consent cookie to true" do
        expect(response.cookies["cookie_consent"].first).to eq("true")
      end
    end
  end
end
