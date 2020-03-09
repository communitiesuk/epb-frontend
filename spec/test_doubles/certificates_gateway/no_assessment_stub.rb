# frozen_string_literal: true

module CertificatesGateway
  class NoAssessmentStub
    def fetch(*)
      { "errors": [{ "code": 'NOT_FOUND', "title": 'Assessment not found' }] }
    end
  end
end
