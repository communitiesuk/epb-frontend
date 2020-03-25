# frozen_string_literal: true

module AssessorsGateway
  class EmptyStub
    def search_by_postcode(*)
      { data: { assessors: [] } }
    end

    def search_by_name(*)
      { data: { assessors: [] } }
    end
  end
end
