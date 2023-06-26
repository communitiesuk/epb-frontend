# frozen_string_literal: true

describe "Acceptance::ViewDecSummary", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-certificate/0000-0000-0000-0000-1111/dec_summary"
  end

  context "when a dec summary exists" do
    before do
      FetchDecSummary::AssessmentStub.fetch(
        assessment_id: "0000-0000-0000-0000-1111",
      )
    end

    it "shows the XML" do
      expect(response.body).to eq("<xml></xml>")
    end
  end

  context "when the assessment doesnt exist" do
    before do
      FetchDecSummary::NoAssessmentStub.fetch(
        assessment_id: "0000-0000-0000-0000-1111",
      )
    end

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end

    it "does not display a back link" do
      expect(response.body).not_to include("Back")
    end
  end

  context "when the assessment has been cancelled or marked not for issue" do
    before do
      FetchDecSummary::GoneAssessmentStub.fetch(
        assessment_id: "0000-0000-0000-0000-1111",
      )
    end

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end

  context "when an assessment that is not a DEC" do
    before do
      FetchDecSummary::AssessmentSummaryErrorStub.fetch(
        assessment_id: "0000-0000-0000-0000-1111",
      )
    end

    it "returns status 404" do
      expect(response.status).to eq(404)
    end

    it "shows the error page" do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>',
      )
    end
  end
end
