describe "Rack::Attack" do
  include RSpecFrontendServiceMixin

  describe "block permanently blocked IP addresses" do
    after do
      Rack::Attack.enabled = false
      Rack::Attack.reset!
    end

    context "when the first entry in x-forwarded for is blacklisted" do
      before do
        # The first time this is called it initialises Rack (RSpecFrontendServiceMixin)
        header "X_FORWARDED_FOR", "198.51.100.100, 127.0.0.1, 198.51.100.200"
        # This why we should only activate Rack::Attack after
        Rack::Attack.enabled = true
      end

      it "returns a 403 forbidden response status" do
        get "/healthcheck"
        expect(last_response.status).to eq(403)
      end
    end

    context "when the first entry in x-forwarded for is not blacklisted" do
      before do
        header "X_FORWARDED_FOR", "198.51.100.200, 127.0.0.1, 198.51.100.220"
        Rack::Attack.enabled = true
      end

      it "returns a 200 OK response status" do
        get "/healthcheck"
        expect(last_response.status).to eq(200)
      end
    end
  end
end
