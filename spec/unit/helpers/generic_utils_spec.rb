describe "helpers util methods", type: :helper do
  let(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  context "when using the #t method to resolve translations" do
    str = "translation"
    translation = "I am the translation"

    before do
      allow(I18n).to receive(:t).with(str, any_args).and_return(translation)
    end

    it "delegates to I18n.t" do
      expect(frontend_service_helpers.t(str)).to eq translation
    end
  end

  context "when using the #h method to escape HTML" do
    html = "<html>"
    escaped_html = "&lt;html&gt;"

    before do
      allow(CGI).to receive(:h).with(html).and_return(escaped_html)
    end

    it "delegates to CGI::h" do
      expect(frontend_service_helpers.h(html)).to eq escaped_html
    end
  end
end
