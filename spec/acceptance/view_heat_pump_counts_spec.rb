describe "Acceptance::HeatPumpCounts " do
  include RSpecFrontendServiceMixin

  let(:response) { get "http://find-energy-certificate.epb-frontend/heat-pump-counts" }

  describe "get . find-energy-certificate/heat-pump-counts" do
    context "when the feature flag is on" do
      before { Helper::Toggles.set_feature("frontend-show-heat-pump-counts", true) }

      context "and the data warehouse api returns a 200 status" do
        before do
          WebMock
            .stub_request(
              :get,
              "http://test-data-warehouse-api.gov.uk/api/heat-pump-counts/floor-area",
            )
            .to_return(status: 200, body: HeatPumpGateway::Stub.api_data)
        end

        it "returns a 200 status" do
          expect(response.status).to eq(200)
        end
      end

      context "and the data warehouse api does not return a 200 status" do
        before do
          WebMock
            .stub_request(
              :get,
              "http://test-data-warehouse-api.gov.uk/api/heat-pump-counts/floor-area",
            )
            .to_return(status: 403, body: HeatPumpGateway::Stub.api_data)
        end

        it "returns a 500 status" do
          expect(response.status).to eq(500)
        end
      end
    end

    context "when the feature flag is off" do
      before do
        Helper::Toggles.set_feature("frontend-show-heat-pump-counts", false)
      end

      it "returns a 404 status" do
        WebMock
          .stub_request(
            :get,
            "http://test-data-warehouse-api.gov.uk/api/heat-pump-counts/floor-area",
          )
          .to_return(status: 200, body: HeatPumpGateway::Stub.api_data)
        expect(response.status).to eq 404
      end

      context "when the api is not available" do
        it "does not return a 500" do
          WebMock
            .stub_request(
              :get,
              "http://test-data-warehouse-api.gov.uk/api/heat-pump-counts/floor-area",
            )
            .to_return(status: 500, body: HeatPumpGateway::Stub.api_data)
          expect(response.status).to eq 404
        end
      end
    end
  end

end
