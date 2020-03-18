module AssessorsGateway
  class NonDomesticStub
    def search_by_postcode(*)
      {
          "results": [
              {
                  "assessor": {
                      "firstName": 'Gregg',
                      "lastName": 'Sellen',
                      "contactDetails": {
                          "telephoneNumber": '0792 102 1368',
                          "email": 'epbassessor@epb.com'
                      },
                      "qualifications": { "nonDomesticSp3": 'ACTIVE' },
                      "searchResultsComparisonPostcode": 'SW1A 1AA',
                      "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                  },
                  "distance": 0.1
              },
              {
                  "assessor": {
                      "firstName": 'Juliet',
                      "lastName": 'Montague',
                      "contactDetails": {
                          "telephoneNumber": '0792 102 1368',
                          "email": 'epbassessor@epb.com'
                      },
                      "qualifications": { "nonDomesticSp3": 'ACTIVE' },
                      "searchResultsComparisonPostcode": 'SW1A 1AA',
                      "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
                  },
                  "distance": 0.3
              }
          ],
          "timestamp": 1_234_567,
          "searchPostcode": 'SW1 5RW'
      }
    end
  end
end
