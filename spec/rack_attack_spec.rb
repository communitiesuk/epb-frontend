describe "Rack::Attack" do
  include RSpecFrontendServiceMixin

  describe "throttle excessive requests by IP address" do
    let(:limit) { 100 }
    let(:under_limit) { limit / 2 }
    let(:over_limit) { limit + 1 }
    let(:certificate_id) { "0000-0000-0000-0000-0000" }

    before do
      Rack::Attack.enabled = true
      header "X_FORWARDED_FOR", "127.0.0.1, 8.8.8.8"
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(certificate_id)
    end

    after do
      Rack::Attack.reset!
      Rack::Attack.enabled = false
    end

    context "when the number of requests is under or at the throttle limit" do
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

    context "when the number of requests is over the throttle limit" do
      it "returns a 429 response status" do
        over_limit.times do |i|
          header "X_FORWARDED_FOR", "127.0.0.1, 8.8.8.8"
          get "/healthcheck"
          expect(last_response.status).to eq(429) if i >= limit
        end
      end
    end

    context "when the number of requests is under or at the ban limit" do
      it "returns a 200 response status under the limit" do
        under_limit.times do
          get "/energy-certificate/#{certificate_id}"
          expect(last_response.status).to eq(200)
        end
      end

      it "returns a 200 response status at the limit" do
        limit.times do
          get "/energy-certificate/#{certificate_id}"
          expect(last_response.status).to eq(200)
        end
      end
    end

    context "when the number of requests is over the ban limit" do
      it "returns a 403 response status" do
        over_limit.times do |i|
          get "/energy-certificate/#{certificate_id}"
          expect(last_response.status).to eq(403) if i >= limit
        end
      end
    end
  end
end
