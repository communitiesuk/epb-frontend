shared_examples "show language toggle" do
  it "shows the language toggle" do
    Helper::Toggles.set_feature("frontend-language-toggle", true)

    expect(response.body).to have_css "ul.language-toggle__list"
    expect(response.body).to have_link "Cymraeg"
    expect(response.body).not_to have_link "English"
  end
end
