require "compare-xml"
require "erubis"
require "nokogiri"
require "ostruct"

describe "ported design system components (in ERB) against govuk-frontend fixtures (see https://frontend.design-system.service.gov.uk/testing-your-html/#test-if-your-html-matches-gov-uk-frontend)", type: :view do
  should_skip = !Dir.exist?("#{__dir__}/../../../node_modules/govuk-frontend/dist/govuk/components")

  if should_skip
    it "tries to test the ported design system components (in ERB) against govuk-frontend fixtures" do
      skip "cannot test components against govuk-frontend as not installed (run `npm install`)"
    end

    break
  end

  implemented_components =
    Dir["#{__dir__}/../../../lib/views/design_system__*.erb"].map do |file|
      file.scan(/design_system__([\w-]+)\.erb/).first.first
    end

  fixtures =
    implemented_components.each_with_object({}) do |component, fixtures_hash|
      fixtures_hash[component.to_sym] = YAML.safe_load(File.open(File.expand_path("#{__dir__}/../../../node_modules/govuk-frontend/dist/govuk/components/#{component.gsub('_', '-')}/fixtures.json")), symbolize_names: true)
    end

  fixtures.each do |component, component_fixtures|
    context "when testing the #{component.to_s.gsub('_', ' ')} ERB against its govuk-frontend fixtures" do
      let(:template) { Erubis::EscapedEruby.new File.read("lib/views/design_system__#{component}.erb") }

      component_fixtures[:fixtures].each do |fixture|
        it "passes against the #{fixture[:name]} fixture" do
          bound_context = OpenStruct.new(**fixture[:options])
          class << bound_context
            include ERB::Util
            include Helpers

            def get_binding
              binding
            end
          end
          expected = fixture[:html]
          actual = template.result(bound_context.get_binding)
          expect(actual).to match_html expected
        end
      end
    end
  end
end
