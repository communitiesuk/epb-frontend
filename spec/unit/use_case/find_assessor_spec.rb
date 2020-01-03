# frozen_string_literal: true
require 'use_case/find_assessor'

describe UseCase::FindAssessor do
  class AssessorsGatewayStub
    attr_writer :assessors

    def initialize
      @assessors = {}
    end

    def search(postcode)
      @assessors
    end
  end

  let (:valid_assessors) do
    [
      {
        "fullName": 'Gregg Sellen',
        "distance": 0,
        "accreditationScheme": 'accreditationScheme',
        "schemeAssessorId": 'schemeAssessorId',
        "telephoneNumber": '0792 102 1368',
        "email": 'epbassessor@epb.com'
      },
      {
        "fullName": 'Juliet Montague',
        "distance": 0,
        "accreditationScheme": 'accreditationScheme',
        "schemeAssessorId": 'schemeAssessorId',
        "telephoneNumber": '0792 102 1368',
        "email": 'epbassessor@epb.com'
      }
    ]
  end

  let(:assessors_gateway) { AssessorsGatewayStub.new }
  let(:find_assessor) { described_class.new(assessors_gateway) }

  #TODO: Implement assessor gateway
  xcontext 'when there are no assessors matched by the postcode' do
    it 'returns a nil' do
      expect(find_assessor.execute('SW1A 2AA')).to eq(nil)
    end
  end

  context 'when there are assessors matched by the postcode' do
    it 'returns list of assessors' do
      expect(find_assessor.execute('SW1A 2AB')).to eq(valid_assessors)
    end
  end
end
