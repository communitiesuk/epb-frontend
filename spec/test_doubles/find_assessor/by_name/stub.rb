# frozen_string_literal: true

module FindAssessor
  module ByName
    class Stub
      def self.search_by_name(name, loose_match = false)
        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?name=#{name}"
        )
          .with(
          headers: {
            Accept: '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            Authorization: 'Bearer abc',
            'User-Agent' => 'Faraday v1.0.1'
          }
        )
          .to_return(
          status: 200,
          body: {
            "data": {
              "assessors": [
                {
                  "firstName": 'Juan',
                  "lastName": 'Uno',
                  "contactDetails": {
                    "telephoneNumber": 'string', "email": 'user@example.com'
                  },
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
                  "schemeAssessorId": 'STROMA9999990'
                },
                {
                  "firstName": 'Doux',
                  "lastName": 'Twose',
                  "contactDetails": {
                    "telephoneNumber": '07921 021 368',
                    "email": 'user@example.com'
                  },
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
                  "schemeAssessorId": '12349876'
                },
                {
                  "firstName": 'Tri',
                  "lastName": 'Triple',
                  "contactDetails": {
                    "telephoneNumber": 'string', "email": 'user@example.com'
                  },
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
                  "schemeAssessorId": '12349876'
                }
              ]
            },
            "meta": { "searchName": name, "looseMatch": loose_match }
          }.to_json
        )
      end
    end
  end
end
