module Helper
  module Response
    def self.ensure_good(&block)
      begin
        response = yield block
      rescue Auth::Errors::NetworkConnectionFailed, Faraday::TimeoutError
        # try once again on a possibly transient network error
        begin
          response = yield block
        rescue StandardError => e
          raise Errors::ConnectionApiError,
                sprintf("Connection to API failed, even after retry. Message from %s: \"%s\"", e.class, e.message)
        end
      end

      if response.status == 401
        raise Errors::ApiAuthorizationError,
              "Authorization issue with internal API. Response body: \"%s\"" %
                response.body
      end
      ensure_json response.body
      unless response.status < 400 ||
          JSON.parse(response.body, symbolize_names: true)[:errors]
        raise Errors::MalformedErrorResponseError,
              sprintf(
                "Internal API response of status code %s had no errors node. Response body: \"%s\"",
                response.status,
                response.body,
              )
      end

      response
    end

    def self.ensure_json(content)
      unless check_valid_json content
        raise Errors::NonJsonResponseError,
              "Response did not contain JSON: \"%s\"" % content
      end
    end

    def self.check_valid_json(content)
      JSON.parse(content)
      true
    rescue JSON::ParserError
      false
    end
  end
end
