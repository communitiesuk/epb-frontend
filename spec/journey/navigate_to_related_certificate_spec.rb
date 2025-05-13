# frozen_string_literal: true

describe "Journey::NavigateToRelatedCertificate", :journey, type: :feature do
  process_id = nil

  before(:all) do
    process =
      IO.popen(
        [
          "rackup",
          "config_test.ru",
          "-q",
          "-o",
          "127.0.0.1",
          "-p",
          "9393",
          { err: %i[child out] },
        ],
      )
    process_id = process.pid

    # Wait until the Puma server has started up before commencing tests
    loop do
      break if process.readline.include?("Listening on http://127.0.0.1:9393")
    end
  end

  after(:all) { Process.kill("KILL", process_id) if process_id }

  before do
    FetchAssessmentSummary::AssessmentStub.fetch_rdsap(
      assessment_id: "0000-0000-0000-0000-0001",
    )
  end

  it "navigates to a related assessment" do
    visit "/energy-certificate/4567-6789-4567-6789-4567"
    click_on "0000-0000-0000-0000-0001"

    expect(find(".epc-box")).to have_content "0000-0000-0000-0000-0001"
  end
end
