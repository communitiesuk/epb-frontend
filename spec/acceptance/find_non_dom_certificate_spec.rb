# frozen_string_literal: true

describe "Acceptance::Non Domestic Certificate" do
  include RSpecFrontendServiceMixin

  describe ".get /find-a-non-domestic-certificate" do
    context "when search page rendered" do
      let(:response) { get "/find-a-non-domestic-certificate" }

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the find a certificate page heading" do
        expect(response.body).to include(
          "Find an energy certificate or report for a non-domestic property",
        )
      end
    end
  end

  describe ".get /find-a-non-domestic-certificate/search-by-postcode" do
    context "when search page rendered" do
      let(:response) do
        get "/find-a-non-domestic-certificate/search-by-postcode"
      end

      it "returns status 200" do
        expect(response.status).to eq(200)
      end

      it "displays the find a non-domestic certificate page heading" do
        expect(response.body).to include(
          "Find energy certificates and reports by postcode",
        )
      end

      it "has an input field" do
        expect(response.body).to include('<input id="postcode" name="postcode"')
      end

      it "has a Find button" do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Find</button>',
        )
      end

      it "does not display an error message" do
        expect(response.body).not_to include("govuk-error-message")
      end
    end

    context "when entering an empty postcode" do
      let(:response) do
        get "/find-a-non-domestic-certificate/search-by-postcode?postcode="
      end

      it "returns status 400" do
        expect(response.status).to eq(400)
      end

      it "displays the find a certificate page heading" do
        expect(response.body).to include(
          "Find an energy performance certificate",
        )
      end

      it "displays an error message" do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">',
        )
        expect(response.body).to include("Enter a real postcode")
      end
    end
  end
end
