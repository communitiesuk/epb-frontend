# frozen_string_literal: true

module AssessorsGateway
  class EmptyStub
    def search_by_postcode(*)
      { "results": [] }
    end

    def search_by_name(*)
      { "results": [] }
    end
  end
end
