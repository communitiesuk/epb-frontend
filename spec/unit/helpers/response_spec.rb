describe Helper::Response do
  context "when a block containing an internal API call is passed to ensure_good" do
    it "passes the response through if the status is 200" do
      response = OpenStruct.new(status: 200, body: { data: [] }.to_json)
      expect(Helper::Response.ensure_good { response }).to eq response
    end

    it "raises a NonJsonResponseError if response content is not valid JSON" do
      response =
        OpenStruct.new(
          status: 200,
          body: "<h1>There is a weird error here.</h1>",
        )
      expect { Helper::Response.ensure_good { response } }.to raise_error(
        Errors::NonJsonResponseError,
      )
    end

    it "raises an ApiAuthorizationError if response status is 401" do
      response =
        OpenStruct.new(
          status: 401,
          body: { errors: ["Some auth issue."] }.to_json,
        )
      expect { Helper::Response.ensure_good { response } }.to raise_error(
        Errors::ApiAuthorizationError,
      )
    end

    it "raises a MalformedErrorResponseError if response status is 4xx-5xx range and response is JSON but has no errors node" do
      response = OpenStruct.new(status: 502, body: {}.to_json)
      expect { Helper::Response.ensure_good { response } }.to raise_error(
        Errors::MalformedErrorResponseError,
        /502/,
      )
    end

    it "passes through the response if response status is 4xx-5xx range and response is JSON and has an errors node" do
      response =
        OpenStruct.new(
          status: 404,
          body: { errors: [{ code: "acme" }] }.to_json,
        )
      expect(Helper::Response.ensure_good { response }).to eq response
    end

    it "retries a request if it throws a NetworkConnectionError on first try" do
      try_count = 0
      good_response = OpenStruct.new(status: 200, body: { data: [] }.to_json)
      make_request =
        lambda do |_|
          try_count += 1
          case try_count
          when 1
            raise Auth::Errors::NetworkConnectionFailed
          else
            good_response
          end
        end
      expect(Helper::Response.ensure_good(&make_request)).to eq good_response
    end

    it "retries a request if it throws a Faraday::TimeoutError on first try" do
      try_count = 0
      good_response = OpenStruct.new(status: 200, body: { data: [] }.to_json)
      make_request =
        lambda do |_|
          try_count += 1
          case try_count
          when 1
            raise Faraday::TimeoutError
          else
            good_response
          end
        end
      expect(Helper::Response.ensure_good(&make_request)).to eq good_response
    end

    it "raises a connection error if raised on retry" do
      expect {
        Helper::Response.ensure_good do
          raise Auth::Errors::NetworkConnectionFailed
        end
      }.to raise_error Errors::ConnectionApiError
    end

    it "raises a response not present error if block does not return something response-ish" do
      bad_response = nil
      expect {
        Helper::Response.ensure_good { bad_response }
      }.to raise_error Errors::ResponseNotPresentError
    end
  end
end
