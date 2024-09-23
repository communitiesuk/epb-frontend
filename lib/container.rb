# frozen_string_literal: true

class Container
  def initialize
    internal_api_client =
      Auth::HttpClient.new ENV["EPB_AUTH_CLIENT_ID"],
                           ENV["EPB_AUTH_CLIENT_SECRET"],
                           ENV["EPB_AUTH_SERVER"],
                           ENV["EPB_API_URL"],
                           OAuth2::Client,
                           faraday_connection_opts: { request: { timeout: 8 } }

    internal_data_warehouse_api_client =
      Auth::HttpClient.new ENV["EPB_AUTH_CLIENT_ID"],
                           ENV["EPB_AUTH_CLIENT_SECRET"],
                           ENV["EPB_AUTH_SERVER"],
                           ENV["EPB_DATA_WAREHOUSE_API_URL"],
                           OAuth2::Client,
                           faraday_connection_opts: { request: { timeout: 8 } }

    assessors_gateway = Gateway::AssessorsGateway.new(internal_api_client)
    certificates_gateway = Gateway::CertificatesGateway.new(internal_api_client)
    assessment_summary_gateway =
      Gateway::AssessmentSummaryGateway.new(internal_api_client)
    find_assessor_by_postcode_use_case =
      UseCase::FindAssessorByPostcode.new(assessors_gateway)
    find_non_domestic_assessor_by_postcode_use_case =
      UseCase::FindNonDomesticAssessorByPostcode.new(assessors_gateway)
    find_assessor_by_name_use_case =
      UseCase::FindAssessorByName.new(assessors_gateway)
    find_certificate_by_postcode_use_case =
      UseCase::FindCertificateByPostcode.new(certificates_gateway)
    find_certificate_by_id_use_case =
      UseCase::FindCertificateById.new(certificates_gateway)
    fetch_certificate_use_case =
      UseCase::FetchCertificate.new(assessment_summary_gateway)
    find_certificate_by_street_name_and_town_use_case =
      UseCase::FindCertificateByStreetNameAndTown.new(certificates_gateway)
    fetch_dec_summary_use_case =
      UseCase::FetchDecSummary.new(certificates_gateway)
    fetch_statistics_use_case = UseCase::FetchStatistics.new(statistics_gateway: Gateway::StatisticsGateway.new(internal_api_client), co2_gateway: Gateway::AverageCo2EmissionsGateway.new(internal_data_warehouse_api_client))
    fetch_statistics_csv_use_case = UseCase::FetchStatisticsCsv.new(statistics_gateway: Gateway::StatisticsGateway.new(internal_api_client), co2_gateway: Gateway::AverageCo2EmissionsGateway.new(internal_data_warehouse_api_client))

    @objects = {
      internal_api_client:,
      internal_data_warehouse_api_client:,
      find_assessor_by_postcode_use_case:,
      find_non_domestic_assessor_by_postcode_use_case:,
      find_assessor_by_name_use_case:,
      fetch_certificate_use_case:,
      find_certificate_by_postcode_use_case:,
      find_certificate_by_id_use_case:,
      find_certificate_by_street_name_and_town_use_case:,
      fetch_dec_summary_use_case:,
      fetch_statistics_use_case:,
      fetch_statistics_csv_use_case:,
    }
  end

  def get_object(key)
    @objects[key]
  end
end
