# frozen_string_literal: true

describe UseCase::FindNonDomesticAssessorByPostcode do
  it 'returns an error when the postcode doesnt exist' do
    find_non_domestic_assessors_without_existing_postcode =
      described_class.new(AssessorsGateway::UnregisteredPostcodeStub.new)

    expect {
      find_non_domestic_assessors_without_existing_postcode.execute('E10 3AD')
    }.to raise_exception Errors::PostcodeNotRegistered
  end

  it 'returns an error when the postcode is not valid' do
    find_non_domestic_assessors_without_valid_postcode =
      described_class.new(AssessorsGateway::InvalidPostcodesStub.new)

    expect {
      find_non_domestic_assessors_without_valid_postcode.execute('E19 0GL')
    }.to raise_exception Errors::PostcodeNotValid
  end

  context 'when there are no assessors matched by the postcode' do
    let(:assessors_gateway) { AssessorsGateway::EmptyStub.new }
    let(:find_non_domestic_assessor) { described_class.new(assessors_gateway) }

    it 'returns empty array' do
      expect(
        find_non_domestic_assessor.execute('SW1A+2AA')[:data][:assessors]
      ).to eq([])
    end
  end

  context 'when there are assessors matched by the postcode' do
    let(:valid_assessors) do
      [
        {
          "firstName": 'Gregg',
          "lastName": 'Sellen',
          "contactDetails": {
            "telephoneNumber": '0792 102 1368', "email": 'epbassessor@epb.com'
          },
          "qualifications": { "nonDomesticSp3": 'ACTIVE' },
          "searchResultsComparisonPostcode": 'SW1A 1AA',
          "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
          "distanceFromPostcodeInMiles": 0.1
        },
        {
          "firstName": 'Juliet',
          "lastName": 'Montague',
          "contactDetails": {
            "telephoneNumber": '0792 102 1368', "email": 'epbassessor@epb.com'
          },
          "qualifications": { "nonDomesticSp3": 'ACTIVE' },
          "searchResultsComparisonPostcode": 'SW1A 1AA',
          "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' },
          "distanceFromPostcodeInMiles": 0.3
        }
      ]
    end

    let(:assessors_gateway) { AssessorsGateway::NonDomesticStub.new }
    let(:find_non_domestic_assessor) { described_class.new(assessors_gateway) }

    it 'returns list of non domestic assessors' do
      expect(
        find_non_domestic_assessor.execute('SW1A+2AB')[:data][:assessors]
      ).to eq(valid_assessors)
    end
  end
end
