describe "Acceptance::ServiceUnavailable", type: :feature do
  include RSpecFrontendServiceMixin

  context "when service unavailable is off" do
    before { Helper::Toggles.set_feature("frontend-maintenance-mode", false) }

    let(:response) do
      get "http://find-energy-certificate.epb-frontend"
    end

    it "returns a 200 status on any existing route" do
      expect(response.status).to eq(200)
    end
  end

  context "when service unavailable is on" do
    before { Helper::Toggles.set_feature("frontend-maintenance-mode", true) }

    after { Helper::Toggles.set_feature("frontend-maintenance-mode", false) }

    let(:response) do
      get "http://find-energy-certificate.epb-frontend"
    end

    it "returns a 503 status on any existing route" do
      expect(response.status).to eq(503)
    end

    it "allows request to the /healthcheck endpoint" do
      response = get "/healthcheck"

      expect(response.status).to be 200
    end

    it "returns a service unavailable page on any existing route" do
      expect(Capybara.string(response.body).title).to include("Sorry, the service is unavailable")
    end

    it "displays an email link for the helpdesk within the copy" do
      expect(Capybara.string(response.body).find(:css, "p.govuk-body a")[:href]).to include "mailto:"
    end
  end
end
