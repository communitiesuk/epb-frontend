# frozen_string_literal: true

module CertificatesGateway
  class EmptyStub
    def search_by_postcode(*)
      { data: { assessments: [] } }
    end

    def search_by_id(*)
      { data: { assessments: [] } }
    end

    def search_by_street_name_and_town(*)
      { data: { assessments: [] } }
    end
  end
end
