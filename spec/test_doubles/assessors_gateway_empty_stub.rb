# frozen_string_literal: true

class AssessorsGatewayEmptyStub
  def search_by_postcode(*)
    { "results": [] }
  end

  def search_by_name(*)
    { "results": [] }
  end
end
