# frozen_string_literal: true

require './lib/gateway/energy_assessments_gateway'
require './lib/use_case/fetch_assessment'

class Container
  def initialize
    internal_api_client =
      Auth::HttpClient.new ENV['EPB_AUTH_CLIENT_ID'],
                           ENV['EPB_AUTH_CLIENT_SECRET'],
                           ENV['EPB_AUTH_SERVER'],
                           ENV['EPB_API_URL'],
                           OAuth2::Client

    assessors_gateway = Gateway::AssessorsGateway.new(internal_api_client)
    find_assessor_use_case = UseCase::FindAssessor.new(assessors_gateway)
    energy_assessments_gateway =
      Gateway::EnergyAssessmentsGateway.new(internal_api_client)
    fetch_assessment_use_case =
      UseCase::FetchAssessment.new(energy_assessments_gateway)

    @objects = {
      internal_api_client: internal_api_client,
      find_assessor_use_case: find_assessor_use_case,
      fetch_assessment_use_case: fetch_assessment_use_case
    }
  end

  def get_object(key)
    @objects[key]
  end
end
