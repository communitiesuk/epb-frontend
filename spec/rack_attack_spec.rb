describe "Rack::Attack" do
  include RSpecFrontendServiceMixin

  describe "throttle excessive requests by IP address" do
    let(:under_limit) { 5 }
    let(:limit) { 10 }

    before do
      Rack::Attack.enabled = true
      Rack::Attack.throttle("IP Limit", limit: limit, period: 1.minutes) do |req|
        if req.forwarded_for.nil? || req.forwarded_for.empty?
          req.ip
        else
          req.forwarded_for.first
        end
      end
    end

    after do
      Rack::Attack.reset!
      Rack::Attack.enabled = false
    end

    context "when the number of requests is under or at the limit" do
      it "returns a 200 response status under the limit" do
        under_limit.times do
          get "/healthcheck"
          expect(last_response.status).to eq(200)
        end
      end
      it "returns a 200 response status at the limit" do
        limit.times do
          get "/healthcheck"
          expect(last_response.status).to eq(200)
        end
      end
    end

    context "when the number of requests is over the limit" do
      it "changes the request status to 429" do
        (limit * 2).times do |i|
          header "X_FORWARDED_FOR", "127.0.0.1, 8.8.8.8"
          get "/healthcheck"
          expect(last_response.status).to eq(429) if i > limit
        end
      end
    end

  end
end

