module Stub
  class InternalClient
    def get(url)
      response_body = {
          "results": [
              {
                  "assessor": {
                      "firstName": 'Juan',
                      "lastName": 'Uno',
                      "contactDetails": {
                          "telephoneNumber": 'string', "email": 'user@example.com'
                      },
                      "searchResultsComparisonPostcode": 'SW1A 1AA',
                      "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                  },
                  "distanceFromPostcodeInMiles": 0.1
              },
              {
                  "assessor": {
                      "firstName": 'Doux',
                      "lastName": 'Twose',
                      "contactDetails": {
                          "telephoneNumber": 'string', "email": 'user@example.com'
                      },
                      "searchResultsComparisonPostcode": 'SW1A 1AA',
                      "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                  },
                  "distanceFromPostcodeInMiles": 0.26780459
              },
              {
                  "assessor": {
                      "firstName": 'Tri',
                      "lastName": 'Triple',
                      "contactDetails": {
                          "telephoneNumber": 'string', "email": 'user@example.com'
                      },
                      "searchResultsComparisonPostcode": 'SW1A 1AA',
                      "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                  },
                  "distanceFromPostcodeInMiles": 0.3
              }
          ],
          "searchPostcode": 'SW1 5RW'
      }

      if url.include? 'BF1+3AA'
        response_body = { "results": [], "searchPostcode": 'BF1 3AA' }
      end

      normal_response(response_body.to_json)
    end

    def normal_response(response_body)
      OAuth2::Response.new Faraday::Response.new status: 200,
                                                 reason_phrase: 'OK',
                                                 response_headers: {},
                                                 body: response_body
    end

  end
end
