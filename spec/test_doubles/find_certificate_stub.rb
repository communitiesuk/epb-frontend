# frozen_string_literal: true

class FindCertificateStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{
        postcode
      }"
    )
      .with(
      headers: {
        Accept: '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        Authorization: 'Bearer abc',
        'User-Agent' => 'Faraday v1.0.0'
      }
    )
      .to_return(
      status: 200,
      body: {
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
            "distance": 0.1
          },
          {
            "assessor": {
              "firstName": 'Doux',
              "lastName": 'Twose',
              "contactDetails": {
                "telephoneNumber": '07921 021 368', "email": 'user@example.com'
              },
              "searchResultsComparisonPostcode": 'SW1A 1AA',
              "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
            },
            "distance": 0.26780459
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
            "distance": 1.36
          }
        ],
        "searchPostcode": 'SW1A 2AA'
      }.to_json
    )
  end
end
