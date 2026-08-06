# frozen_string_literal: true

describe "Journey::NavigateToRelatedCertificate", :journey, type: :feature do
  before do
    FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
      assessment_id: "0000-0000-0000-0000-0001",
    )
  end

  it "navigates to a related assessment" do
    visit "/energy-certificate/4567-6789-4567-6789-4567"
    click_link "0000-0000-0000-0000-0001"

    expect(find(".epc-box")).to have_content "0000-0000-0000-0000-0001"
  end
end
