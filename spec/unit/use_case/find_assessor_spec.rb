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

  class AssessorsGatewayWithoutValidPostcode
    def search(postcode)
      {
        "errors": [
          {
            "code": 'INVALID_REQUEST',
            "title": 'The requested postcode is not valid'
          }
        ]
      }
    end
  end

  class AssessorsGatewayWithoutScheme
    def search(postcode)
      {
        "errors": [
          {
            "code": 'SCHEME_NOT_FOUND',
            "message": 'There is no scheme for one of the requested assessor'
          }
        ]
      }
    end
  end

  class AssessorsGatewayWithoutExistingPostcode
    def search(postcode)
      {
        "errors": [
          {
            "code": 'NOT_FOUND',
            "message": 'The requested postcode is not registered'
          }
        ]
      }
    end
  end

  it 'returns an error when the postcode doesnt exist' do
    find_assessors_without_existing_postcode =
      described_class.new(AssessorsGatewayWithoutExistingPostcode.new)

    expect {
      find_assessors_without_existing_postcode.execute('E10 3AD')
    }.to raise_exception UseCase::FindAssessor::PostcodeNotRegistered
  end

  it 'returns an error when there is no scheme' do
    find_assessor_without_scheme =
      described_class.new(AssessorsGatewayWithoutScheme.new)

    expect {
      find_assessor_without_scheme.execute('E11 0GL')
    }.to raise_exception UseCase::FindAssessor::SchemeNotFound
  end

  it 'returns an error when the postcode is not valid' do
    find_assessor_without_valid_postcode =
      described_class.new(AssessorsGatewayWithoutValidPostcode.new)

    expect {
      find_assessor_without_valid_postcode.execute('E19 0GL')
    }.to raise_exception UseCase::FindAssessor::PostcodeNotValid
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
