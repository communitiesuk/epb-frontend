# frozen_string_literal: true

module Errors
  class AssessmentNotFound < RuntimeError
  end
  class AuthTokenMissing < RuntimeError
  end
  class CertificateNotFound < RuntimeError
  end
  class InvalidName < StandardError
  end

  class PostcodeNotRegistered < RuntimeError
  end
  class PostcodeNotValid < RuntimeError
  end

  class ReferenceNumberNotValid < RuntimeError
  end

  class AllParamsMissing < RuntimeError
  end
  class StreetNameMissing < RuntimeError
  end
  class TownMissing < RuntimeError
  end
end
