module FindCertificate
  class TimeoutStub
    def self.search_by_street_name_and_town(street_name, town, assessment_types:)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessmentTypes=#{assessment_types.sort.join(',')}&street=#{
            street_name
          }&town=#{town}",
        )
        .to_raise(Faraday::TimeoutError)
    end
  end
end
