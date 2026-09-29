describe "Acceptance::HeatPumpCounts" do
  include RSpecFrontendServiceMixin

  describe "get find-energy-certificate/heat-pump-counts" do
    context "when the feature flag is on" do
      before { Helper::Toggles.set_feature("frontend-show-heat-pump-counts", true) }

      context "and the data warehouse api returns a 200 status" do
        it "returns a 200 status" do
          HeatPumpGateway::Stub.count_by_floor_area
          get "http://find-energy-certificate.epb-frontend/heat-pump-counts"
          expect(last_response.status).to eq(200)
        end
      end

      context "and the data warehouse api does not return a 200 status" do
        it "returns a 500 status" do
          HeatPumpGateway::Stub.count_by_floor_area(status: 500)
          expect {
            get "http://find-energy-certificate.epb-frontend/heat-pump-counts"
          }.to raise_error Errors::MalformedErrorResponseError
        end
      end
    end

    context "when the feature flag is off" do
      before do
        Helper::Toggles.set_feature("frontend-show-heat-pump-counts", false)
      end

      it "returns a 404 status" do
        HeatPumpGateway::Stub.count_by_floor_area
        get "http://find-energy-certificate.epb-frontend/heat-pump-counts"
        expect(last_response.status).to eq 404
      end

      context "when the api is not available" do
        it "does not return a 500" do
          HeatPumpGateway::Stub.count_by_floor_area(status: 500)
          get "http://find-energy-certificate.epb-frontend/heat-pump-counts"
          expect(last_response.status).to eq 404
        end
      end
    end
  end
end
