describe "Rack::Attack" do
  include RSpecFrontendServiceMixin
  describe "allow white listed IP addresses" do
    let(:limit) { 100 }
    let(:under_limit) { limit / 2 }
    let(:over_limit) { limit + 1 }
    let(:certificate_id) { "0000-0000-0000-0000-0000" }

    context "when IP address is added to whitelist" do
      before do
        stub_const("ENV", { "WHITELISTED_IP_ADDRESSES" => "127.0.0.1" })
        header "X_FORWARDED_FOR", "198.51.100.200, 127.0.0.1, 198.51.100.220"
        Rack::Attack.enabled = true
      end

      it "returns a 200 OK response status" do
        get "/healthcheck"
        expect(last_response.status).to eq(200)
      end
    end

    context "when IP address ranges are added to whitelist" do
      before do
        white_list = '[{"reason":"pen testers march 2022", "ip_addresses": ["37.200.119.11","185.10.12.32/28","176.65.68.112/28","2a00:1430:2106::/48"]}]'
        stub_const("ENV", { "WHITELISTED_IP_ADDRESSES" => white_list })
        header "X_FORWARDED_FOR", "37.200.119.11, 185.10.12.32.240, 198.51.100.220"
        Rack::Attack.enabled = true
      end

      it "returns a 200 OK response status" do
        get "/healthcheck"
        expect(last_response.status).to eq(200)
      end
    end
  end
end
