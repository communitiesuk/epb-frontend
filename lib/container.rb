# frozen_string_literal: true

class Container
  def initialize
    internal_api_client =
      Auth::HttpClient.new ENV['EPB_AUTH_CLIENT_ID'],
                           ENV['EPB_AUTH_CLIENT_SECRET'],
                           ENV['EPB_AUTH_SERVER'],
                           ENV['EPB_API_URL'],
                           OAuth2::Client

    assessors_gateway = Gateway::AssessorsGateway.new(internal_api_client)
    certificates_gateway = Gateway::CertificatesGateway.new(internal_api_client)
    find_assessor_use_case = UseCase::FindAssessor.new(assessors_gateway)
    find_certificate_use_case = UseCase::FindCertificate.new(certificates_gateway)
    fetch_assessment_use_case =
      RemoteUseCase::FetchAssessment.new(internal_api_client)

    @objects = {
      internal_api_client: internal_api_client,
      find_assessor_use_case: find_assessor_use_case,
      fetch_assessment_use_case: fetch_assessment_use_case,
      find_certificate_use_case: find_certificate_use_case
    }
  end

  def get_object(key)
    @objects[key]
  end
end
