describe "Acceptance::ServiceUnavailable", type: :feature do
  include RSpecFrontendServiceMixin

  context "when service unavailable is off" do
    before { Helper::Toggles.set_feature("frontend-maintenance-mode", false) }

    let(:response) do
      get "http://find-energy-certificate.epb-frontend"
    end

    it "returns a 200 status on any existing route" do
      expect(response.status).to eq 200
    end
  end

  context "when service unavailable is on" do
    before { Helper::Toggles.set_feature("frontend-maintenance-mode", true) }
    after { Helper::Toggles.set_feature("frontend-maintenance-mode", false) }

    context "when visiting the home page" do
      let(:response) do
        get "http://find-energy-certificate.epb-frontend/"
      end

      it "returns a 503 status" do
        expect(response.status).to eq 503
        expect(response.body).to have_title "Sorry, the service is unavailable"
        expect(response.body).to have_css 'p.govuk-body a[href^="mailto:"]'
      end
    end

    context "when visiting a deep link" do
      let(:response) do
        get "http://getting-new-energy-certificate.epb-frontend/find-an-assessor/type-of-domestic-property"
      end

      it "returns a 503 status" do
        expect(response.status).to eq 503
        expect(response.body).to have_title "Sorry, the service is unavailable"
        expect(response.body).to have_css 'p.govuk-body a[href^="mailto:"]'
      end
    end

    context "when visiting the healthcheck page" do
      let(:response) do
        get "http://find-energy-certificate.epb-frontend/healthcheck"
      end

      it "returns a 200 status" do
        expect(response.status).to be 200
      end
    end

    context "when visiting in welsh" do
      let(:response) do
        get "http://find-energy-certificate.epb-frontend/accessibility-statement?lang=cy"
      end

      it "returns the service unavailable page in Welsh" do
        expect(response.status).to eq 503
        expect(response.body).to have_title "Ymddiheuriadau. Nid yw’r gwasanaeth ar gael. – GOV.UK"
      end
    end

    context "when visiting a page that doesn't exist" do
      let(:response) do
        get "http://find-energy-certificate.epb-frontend/xxxx"
      end

      it "returns the service unavailable page" do
        expect(response.status).to eq 503
        expect(response.body).to have_title "Sorry, the service is unavailable"
      end
    end
  end
end
