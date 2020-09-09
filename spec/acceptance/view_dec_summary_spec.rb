# frozen_string_literal: true

describe "Acceptance::ViewDecSummary", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "/energy-performance-certificate/0000-0000-0000-0000-1111/dec_summary"
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
end
