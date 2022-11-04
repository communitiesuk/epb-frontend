describe "locales" do
  let(:identify_missing_welsh_translations_rake) { get_task("identify_missing_welsh_translations") }
  let(:identify_missing_english_translations_rake) { get_task("identify_missing_english_translations") }

  it "has no missing keys in the welsh translation" do
    expect { identify_missing_welsh_translations_rake.invoke }.to output("Nothing missing from .\n").to_stdout
  end

  it "has no missing keys in the english translation" do
    expect { identify_missing_english_translations_rake.invoke }.to output("Nothing missing from .\n").to_stdout
  end
end
