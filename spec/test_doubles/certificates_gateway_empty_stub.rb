# frozen_string_literal: true

class CertificatesGatewayEmptyStub
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
