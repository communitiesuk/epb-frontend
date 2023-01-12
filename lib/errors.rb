# frozen_string_literal: true

module Errors
  class AssessmentGone < RuntimeError
  end

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

  class PostcodeWrongFormat < RuntimeError
  end

  class PostcodeIncomplete < RuntimeError
  end

  class ReferenceNumberNotValid < RuntimeError
  end

  class AllParamsMissing < RuntimeError
  end

  class StreetNameMissing < RuntimeError
  end

  class TownMissing < RuntimeError
  end

  class AssessmentUnsupported < RuntimeError
  end

  class ApiError < RuntimeError
  end

  class ConfigurationError < RuntimeError
  end

  class NonJsonResponseError < ApiError
  end

  class ApiAuthorizationError < ApiError
  end

  class MalformedErrorResponseError < ApiError
  end

  class UnknownErrorResponseError < ApiError
  end

  class ConnectionApiError < ApiError
  end

  class RequestTimeoutError < ConnectionApiError
  end

  class ResponseNotPresentError < ApiError
  end

  class UriTooLong < RuntimeError
  end

  class BotDetected < RuntimeError
  end

  class ReportIncomplete < ApiError
  end

  class TooManyResults < ApiError
  end

  # a module to include in an error class when errors of that type should not be reported to e.g. Sentry
  module DoNotReport
  end
end
