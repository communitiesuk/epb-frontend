module UseCase
  class Base
    def initialize(gateway)
      @gateway = gateway
    end

    def raise_errors_if_exists(response)
      if response.include?(:errors)
        response[:errors].each do |error|
          if error[:code] == 'Auth::Errors::TokenMissing'
            raise Errors::AuthTokenMissing
          end
          yield(error[:code])
        end
      end
    end
  end
end
