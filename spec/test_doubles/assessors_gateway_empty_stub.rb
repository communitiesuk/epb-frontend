# frozen_string_literal: true

class AssessorsGatewayEmptyStub
  def search(*)
    { "results": [] }
  end
end
