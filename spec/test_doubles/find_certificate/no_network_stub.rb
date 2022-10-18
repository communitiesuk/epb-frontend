# frozen_string_literal: true

module FindCertificate
  class NoNetworkStub
    def self.search_by_postcode(postcode)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?postcode=#{postcode}",
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

    def self.search_by_street_name_and_town(street_name, town)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?street=#{
            street_name
          }&town=#{town}",
        )
        .to_raise(Auth::Errors::NetworkConnectionFailed)
    end
  end
end
