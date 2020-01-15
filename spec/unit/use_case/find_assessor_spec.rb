# frozen_string_literal: true

describe UseCase::FindAssessor do
  class AssessorsGatewayStub
    def search(postcode)
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

  class NoAssessorsGatewayStub
    def search(postcode)
      { "results": [] }
    end
  end

  context 'when there are no assessors matched by the postcode' do
    let(:assessors_gateway) { NoAssessorsGatewayStub.new }
    let(:find_assessor) { described_class.new(assessors_gateway) }

    it 'returns empty array' do
      expect(find_assessor.execute('SW1A+2AA')).to eq([])
    end
  end

  context 'when there are assessors matched by the postcode' do
    let (:valid_assessors) do
      [
        {
          "fullName": 'Gregg Sellen',
          "distance": 0.1,
          "accreditationScheme": 'EPBs 4 U',
          "schemeAssessorId": '432',
          "telephoneNumber": '0792 102 1368',
          "email": 'epbassessor@epb.com'
        },
        {
          "fullName": 'Juliet Montague',
          "distance": 0.3,
          "accreditationScheme": 'EPBs 4 U',
          "schemeAssessorId": '432',
          "telephoneNumber": '0792 102 1368',
          "email": 'epbassessor@epb.com'
        }
      ]
    end

    let(:assessors_gateway) { AssessorsGatewayStub.new }
    let(:find_assessor) { described_class.new(assessors_gateway) }

    it 'returns list of assessors' do
      expect(find_assessor.execute('SW1A+2AB')).to eq(valid_assessors)
    end
  end
end
