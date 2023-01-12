# frozen_string_literal: true

module UseCase
  class Base
    def initialize(gateway)
      @gateway = gateway
    end

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
