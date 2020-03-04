# frozen_string_literal: true

module CertificatesGateway
  class EmptyStub
    def search_by_postcode(*)
      { "results": [] }
    end

    def search_by_id(*)
      { "results": [] }
    end

    def search_by_street_name_and_town(*)
      { "results": [] }
    end
  end
end
