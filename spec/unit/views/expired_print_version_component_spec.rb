require "erubis"
require "date"

describe "expired_print_version_component", type: :view do
  it "displays a warning title" do
    expect(
      expired_print_version("certificate").find(".govuk-warning-text__assistive").text,
    ).to eq "Warning"
  end

  it "displays certificate text for certificates" do
    expect(
      expired_print_version("certificate").find(".govuk-warning-text__text").first(".govuk-body").text,
    ).to eq " This certificate has expired."
  end

  it "does not display report text for certificates" do
    expect(
      expired_print_version("certificate").find(".govuk-warning-text__text").text,
      ).to_not include "report"
  end

  it "displays report text for reports" do
    expect(
      expired_print_version("report").find(".govuk-warning-text__text").first(".govuk-body").text,
    ).to eq " This report has expired."
  end


  def render(type)
    Erubis::EscapedEruby
      .new(template)
      .result(create_binding({ type:,
                               assessment: { dateOfExpiry: Date.new(2020, 10, 8), supersededBy: nil },
                               print_view: true }))
  end

  def mount(type)
    Capybara.string(render(type))
  end

  def template
    File.read("lib/views/component__expired_print_version.erb")
  end

  def expired_print_version(type)
    mount(type).find(".epc-blue-bottom")
  end

  def create_binding(hash)
    context = OpenStruct.new(**hash)
    class << context
      include ERB::Util
      include Helpers

      def get_binding
        binding
      end
    end
    context.get_binding
  end
end
