# frozen_string_literal: true

module FindAssessor
  module ByPostcode
    class Stub
      def self.search_by_postcode(
        postcode, qualification_type = 'domesticSap,domesticRdSap'
      )
        if qualification_type ==
             'nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5'
          qualification_status = {
            'domesticSap': 'ACTIVE',
            'domesticRdSap': 'ACTIVE',
            'nonDomesticSp3': 'ACTIVE',
            'nonDomesticCc4': 'ACTIVE',
            'nonDomesticDec': 'ACTIVE',
            'nonDomesticNos3': 'ACTIVE',
            'nonDomesticNos4': 'ACTIVE',
            'nonDomesticNos5': 'ACTIVE'
          }
        else
          qualification_status = {
            'domesticSap': 'ACTIVE',
            'domesticRdSap': 'ACTIVE'
          }
        end

        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?postcode=#{
            postcode
          }&qualification=#{qualification_type}"
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
                  "qualifications": qualification_status,
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
                  "schemeAssessorId": 'STROMA9999990',
                  "distanceFromPostcodeInMiles": 0.1
                },
                {
                  "firstName": 'Doux',
                  "lastName": 'Twose',
                  "contactDetails": {
                    "telephoneNumber": '07921 021 368',
                    "email": 'user@example.com'
                  },
                  "qualifications": qualification_status,
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
                  "schemeAssessorId": '12349876',
                  "distanceFromPostcodeInMiles": 0.26780459
                },
                {
                  "firstName": 'Tri',
                  "lastName": 'Triple',
                  "contactDetails": {
                    "telephoneNumber": 'string', "email": 'user@example.com'
                  },
                  "qualifications": qualification_status,
                  "searchResultsComparisonPostcode": 'SW1A 1AA',
                  "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
                  "schemeAssessorId": '12349876',
                  "distanceFromPostcodeInMiles": 1.36
                }
              ]
            },
            "meta": { "searchPostcode": 'SW1A 2AA' }
          }.to_json
        )
      end
    end
  end
end
