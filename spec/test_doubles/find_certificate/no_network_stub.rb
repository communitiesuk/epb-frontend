# frozen_string_literal: true

module FindCertificate
  class NoNetworkStub
    def self.search_by_postcode(postcode, assessment_types:)
      ensure_token
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessmentTypes=#{assessment_types.sort.join(',')}&postcode=#{postcode}",
        )
        .to_raise(Auth::Errors::NetworkConnectionFailed)
    end

    def self.search_by_id(certificate_id)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessmentId=#{
            certificate_id
          }",
        )
        .to_raise(Auth::Errors::NetworkConnectionFailed)
    end

    def self.search_by_street_name_and_town(street_name, town, assessment_types:)
      ensure_token
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessmentTypes=#{assessment_types.sort.join(',')}&street=#{
            street_name
          }&town=#{town}",
        )
        .to_raise(Auth::Errors::NetworkConnectionFailed)
    end

    def self.ensure_token
      OauthStub.token
    end

    private_class_method :ensure_token
  end
end
