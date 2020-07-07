# frozen_string_literal: true

describe "Journey::NavigateToRelatedCertificate",
         type: :feature, journey: true do
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
          err: %i[child out],
        ],
      )
    @process_id = process.pid

    unless process.readline.include?("port=9393")
    end
  end

  after(:all) { Process.kill("KILL", @process_id) }

  before { FetchCertificate::Stub.fetch("0000-0000-0000-0000-0001") }

  it "navigates to a related assessment" do
    visit "/energy-performance-certificate/4567-6789-4567-6789-4567"
    click_on "0000-0000-0000-0000-0001"

    expect(find(".epc-box")).to have_content "0000-0000-0000-0000-0001"
  end
end
