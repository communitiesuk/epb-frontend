# frozen_string_literal: true

class CertificatesGatewayEmptyStub
  def search(*)
    { "results": [] }
  end
end
