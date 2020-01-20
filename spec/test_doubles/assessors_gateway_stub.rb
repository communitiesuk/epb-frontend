# frozen_string_literal: true

class AssessorsGatewayStub
  def search(*)
    {
      "results": [
        {
          "assessor": {
            "firstName": 'Gregg',
            "lastName": 'Sellen',
            "contactDetails": {
              "telephoneNumber": '0792 102 1368', "email": 'epbassessor@epb.com'
            },
            "searchResultsComparisonPostcode": 'SW1A 1AA',
            "distance": 0.1,
            "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
          }
        },
        {
          "assessor": {
            "firstName": 'Juliet',
            "lastName": 'Montague',
            "contactDetails": {
              "telephoneNumber": '0792 102 1368', "email": 'epbassessor@epb.com'
            },
            "searchResultsComparisonPostcode": 'SW1A 1AA',
            "distance": 0.3,
            "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
          }
        }
      ],
      "timestamp": 1_234_567,
      "searchPostcode": 'SW1 5RW'
    }
  end
end
