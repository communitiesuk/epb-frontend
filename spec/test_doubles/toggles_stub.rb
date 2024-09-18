class TogglesStub
  def self.enable(features)
    domain = ENV["EPB_UNLEASH_URI"]

    WebMock.stub_request(:post, /#{domain}.*/)

    WebMock
      .stub_request(:get, /#{domain}.*/)
      .to_return(
        status: 200,
        body:
          JSON.generate(
            {
              version: 1,
              features: features.nil? || features.empty? ? [] : construct_features_body(features),
            },
          ),
      )
  end

  def self.construct_features_body(features)
    features
      .enum_for(:each_with_index)
      .map do |feature|
        {
          name: feature[0],
          description: "Test feature #{feature[0]}",
          enabled: feature[1],
          strategies: [{ name: "default" }],
          variants: nil,
          createdAt: "2019-11-14T14:24:44.277Z",
        }
      end
  end

  private_class_method :construct_features_body
end
