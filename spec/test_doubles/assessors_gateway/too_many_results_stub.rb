# frozen_string_literal: true

module AssessorsGateway
  class TooManyResultsStub
    def search_by_name(*)
      {
        "errors": [{ "code": "TOO_MANY_RESULTS", "title": "Too many results" }],
      }
    end
  end
end
