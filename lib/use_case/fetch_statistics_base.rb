module UseCase
  class FetchStatisticsBase
    def initialize(statistics_gateway:, co2_gateway:)
      @statistics_gateway = statistics_gateway
      @co2_gateway = co2_gateway
    end

  private

    def raise_errors_if_exists(response)
      return unless response.include?(:errors)

      response[:errors].each do |error|
        if error[:code] == "Auth::Errors::TokenMissing"
          raise Errors::AuthTokenMissing
        end
        if error[:code] == "PAYLOAD_TOO_LARGE"
          raise Errors::TooManyResults
        end

        yield(error) if block_given?
      end

      raise Errors::UnknownErrorResponseError,
            sprintf(
              "Unknown error response from internal API; errors sent were: %s",
              response[:errors].to_s,
            )
    end
  end
end
