describe "Rack::Attack" do
  include RSpecFrontendServiceMixin

  describe "allow all requests for whitelisted IP address" do
    let(:limit) { 100 }
    let(:under_limit) { limit / 2 }
    let(:over_limit) { limit + 1 }
    let(:certificate_id) { "0000-0000-0000-0000-0000" }

    before do
      # The first time this is called it initialises Rack (RSpecFrontendServiceMixin)
      header "X_FORWARDED_FOR", "198.51.100.111, 127.0.0.1, 198.51.100.200"
      # This why we should only activate Rack::Attack after
      Rack::Attack.enabled = true
      FetchAssessmentSummary::AssessmentStub.fetch_rdsap(assessment_id: certificate_id)
    end

    after do
      Rack::Attack.enabled = false
      Rack::Attack.reset!
    end

    context "when the number of requests is under, at or over the throttle limit" do
      it "returns a 200 response status under the limit" do
        under_limit.times do
          get "/healthcheck"
        end
        expect(last_response.status).to eq(200)
      end

      it "returns a 200 response status at the limit" do
        limit.times do
          get "/healthcheck"
        end
        expect(last_response.status).to eq(200)
      end

      it "returns a 200 response status over the limit" do
        over_limit.times do
          get "/healthcheck"
        end
        expect(last_response.status).to eq(200)
      end
    end

    context "when the number of requests is under, at or over the ban limit" do
      it "returns a 200 response status under the limit" do
        under_limit.times do
          get "/energy-certificate/#{certificate_id}"
        end
        expect(last_response.status).to eq(200)
      end

      it "returns a 200 response status at the limit" do
        limit.times do
          get "/energy-certificate/#{certificate_id}"
        end
        expect(last_response.status).to eq(200)
      end

      it "returns a 200 response status over the limit" do
        over_limit.times do
          get "/energy-certificate/#{certificate_id}"
        end
        expect(last_response.status).to eq(200)
      end
    end
  end
end
