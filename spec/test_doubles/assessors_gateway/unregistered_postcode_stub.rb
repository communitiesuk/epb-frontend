# frozen_string_literal: true

module AssessorsGateway
  class UnregisteredPostcodeStub
    def search_by_postcode(*)
      {
        "errors": [
          {
            "code": 'NOT_FOUND',
            "message": 'The requested postcode is not registered'
          }
        ]
      }
    end
  end
end
