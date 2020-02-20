# frozen_string_literal: true

class AssessorsGatewayTooManyResultsStub
  def search_by_name(*)
    { "errors": [{ "code": 'TOO_MANY_RESULTS', "title": 'Too many results' }] }
  end
end
