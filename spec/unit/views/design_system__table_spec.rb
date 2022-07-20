require "erubis"

describe "design_system__table", type: :view do
  it "can have additional classes" do
    expect(
      table("classes")[:class].split.include?("custom-class-goes-here"),
    ).to be true
  end

  it "can have additional attributes" do
    expect(table("attributes")["data-foo".to_sym]).to eq "bar"
  end

  describe "captions" do
    let(:caption) do
      mount("table with head and caption").find(".govuk-table__caption")
    end

    it "can have custom text" do
      expect(caption.text).to eq "Caption 1: Months and rates"
    end

    it "can have additional classes" do
      expect(caption[:class].split.include?("govuk-heading-m")).to be true
    end
  end

  describe "column headers" do
    it "can be specified" do
      headings = table("table with head").all("thead tr th").map(&:text)
      expect(headings).to eq [
        "Month you apply",
        "Rate for bicycles",
        "Rate for vehicles",
      ]
    end

    it "have HTML escaped when passed as text" do
      heading = table("html as text").find("thead tr th")
      expect(
        heading.native.inner_html,
      ).to eq "Foo &lt;script&gt;hacking.do(1337)&lt;/script&gt;"
    end

    it "allow HTML when passed as HTML" do
      heading = table("html").find("thead tr th")
      expect(heading.native.inner_html).to eq "Foo <span>bar</span>"
    end

    it "can have a format specified" do
      heading = table("table with head").all("thead tr th")[-1]
      expect(
        heading[:class].split.include?("govuk-table__header--numeric"),
      ).to be true
    end

    it "can have additional classes" do
      heading = table("head with classes").find("thead tr th")
      expect(heading[:class].split.include?("my-custom-class")).to be true
    end

    it "can have rowspan specified" do
      heading = table("head with rowspan and colspan").find("thead tr th")
      expect(heading[:rowspan]).to eq "2"
    end

    it "can have colspan specified" do
      heading = table("head with rowspan and colspan").find("thead tr th")
      expect(heading[:colspan]).to eq "2"
    end

    it "can have additional attributes" do
      heading = table("head with attributes").find("thead tr th")
      expect(heading[:"data-fizz"]).to eq "buzz"
    end
  end

  describe "row headers" do
    describe "when firstCellIsHeader is false" do
      it "are not included" do
        cells = table("default").all("tbody tr td").map(&:text)
        expect(cells).to eq %w[January £85 £95 February £75 £55 March £165 £125]
      end
    end

    describe "when firstCellIsHeader is true" do
      it "are included" do
        headings =
          table("with firstCellIsHeader true").all("tbody tr th").map(&:text)
        expect(headings).to eq %w[January February March]
      end

      it "have HTML escaped when passed as text" do
        heading =
          table("firstCellIsHeader with html as text").find("tbody tr th")
        expect(
          heading.native.inner_html,
        ).to eq "Foo &lt;script&gt;hacking.do(1337)&lt;/script&gt;"
      end

      it "allow HTML when passed as HTML" do
        heading = table("firstCellIsHeader with html").find("tbody tr th")
        expect(heading.native.inner_html).to eq "Foo <span>bar</span>"
      end

      it 'are associated with rows using scope="row"' do
        heading = table("with firstCellIsHeader true").first("tbody tr th")
        expect(heading[:scope]).to eq "row"
      end

      it "have the govuk-table__header class" do
        heading = table("with firstCellIsHeader true").first("tbody tr th")
        expect(heading[:class].split.include?("govuk-table__header")).to be true
      end

      it "can have additional classes" do
        heading = table("firstCellIsHeader with classes").find("tbody tr th")
        expect(heading[:class].split.include?("my-custom-class")).to be true
      end

      it "can have rowspan specified" do
        heading =
          table("firstCellIsHeader with rowspan and colspan").find(
            "tbody tr th",
          )
        expect(heading[:rowspan]).to eq "2"
      end

      it "can have colspan specified" do
        heading =
          table("firstCellIsHeader with rowspan and colspan").find(
            "tbody tr th",
          )
        expect(heading[:colspan]).to eq "2"
      end

      it "can have additional attributes" do
        heading = table("firstCellIsHeader with attributes").find("tbody tr th")
        expect(heading[:"data-fizz"]).to eq "buzz"
      end
    end
  end

  describe "cells" do
    it "can be specified" do
      cells =
        table("default").all("tbody tr").map { |row| row.all("td").map(&:text) }
      expect(cells).to eq [
        %w[January £85 £95],
        %w[February £75 £55],
        %w[March £165 £125],
      ]
    end

    it "can be skipped when falsy" do
      table = table("with falsey items") # (sic)
      cells = table.all("tbody tr").map { |row| row.all("td").map(&:text) }
      expect(cells).to eq [%w[A 1], %w[B 2], %w[C 3]]
    end

    it "have HTML escaped when passed as text" do
      td = table("html as text").find("td")
      expect(
        td.native.inner_html,
      ).to eq "Foo &lt;script&gt;hacking.do(1337)&lt;/script&gt;"
    end

    it "allow HTML when passed as HTML" do
      td = table("html").find("td")
      expect(td.native.inner_html).to eq "Foo <span>bar</span>"
    end

    it "can have a format specified" do
      td = table("default").all("td")[-1]
      expect(td[:class].split.include?("govuk-table__cell--numeric")).to be true
    end

    it "can have additional classes" do
      td = table("rows with classes").find("td")
      expect(td[:class].split.include?("my-custom-class")).to be true
    end

    it "can have rowspan specified" do
      td = table("rows with rowspan and colspan").find("td")
      expect(td[:rowspan]).to eq "2"
    end

    it "can have colspan specified" do
      td = table("rows with rowspan and colspan").find("td")
      expect(td[:colspan]).to eq "2"
    end

    it "can have additional attributes" do
      td = table("rows with attributes").find("td")
      expect(td[:"data-fizz"]).to eq "buzz"
    end
  end

  def example(name)
    examples.find { |example| example["name"] == name }
  end

  def examples
    YAML.safe_load(
      File.open(
        File.expand_path("#{File.dirname(__FILE__)}/examples/table.yaml"),
      ),
    )[
      "examples"
    ]
  end

  def render(example_name)
    Erubis::EscapedEruby
      .new(template)
      .result(create_binding(symbolize_keys(example(example_name)["data"])))
  end

  def mount(example_name)
    Capybara.string(render(example_name))
  end

  def table(example_name)
    mount(example_name).find(".govuk-table")
  end

  def template
    File.read("lib/views/#{self.class.top_level_description}.erb")
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

  def symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key =
        case key
        when String
          key.to_sym
        else
          key
        end
      result[new_key] = symbolize_value value
    end
  end

  def symbolize_value(value)
    case value
    when Hash
      symbolize_keys(value)
    when Enumerable
      value.map { |val| symbolize_value val }
    else
      value
    end
  end
end
