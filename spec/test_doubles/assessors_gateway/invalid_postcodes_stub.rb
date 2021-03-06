# frozen_string_literal: true

module AssessorsGateway
  class InvalidPostcodesStub
    def search_by_postcode(*)
      {
        "errors": [
          {
            "code": "INVALID_REQUEST",
            "title": "The requested postcode is not valid",
          },
        ],
      }
    end
  end
end
