describe "helpers.safe_join", type: :helper do
  let(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  it "joins an array html escaping the elements and not the joiner" do
    expect(
      frontend_service_helpers.safe_join(["1", "<b>2</b>"], "<br>"),
    ).to eq "1<br>&lt;b&gt;2&lt;/b&gt;"
  end
end
