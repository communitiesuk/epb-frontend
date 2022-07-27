%i[script style].each do |element_name|
  shared_examples "all #{element_name} elements have nonce attributes" do
    it "has a nonce attribute on every #{element_name} element" do
      expect(
        Capybara.string(response.body)
                .all(:element, element_name.to_s, visible: false)
                .reject { |element| element.has_ancestor? "svg" } # anything within an SVG can be disregarded
                .all? { |element| element["nonce"] },
      ).to be true
    end
  end
end
