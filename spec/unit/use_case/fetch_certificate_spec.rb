# frozen_string_literal: true

describe UseCase::FetchCertificate do
  include RSpecUnitMixin

  context 'when an assessment doesnt exist' do
    let(:certificates_gateway) { CertificatesGateway::NoAssessmentStub.new }
    let(:fetch_certificate) { described_class.new(certificates_gateway) }

    it 'raises an AssessmentNotFound error' do
      expect { fetch_certificate.execute('123-456') }.to raise_error(
        Errors::AssessmentNotFound
      )
    end
  end

  context 'when an assessment does exist' do
    let(:certificates_gateway) { CertificatesGateway::Stub.new }
    let(:fetch_certificate) { described_class.new(certificates_gateway) }

    it 'returns assessments' do
      result = fetch_certificate.execute('223-456')
      expect(result).to eq(
        assessor: {
          firstName: 'Test',
          lastName: 'Boi',
          registeredBy: { name: 'Quidos', schemeId: 1 },
          schemeAssessorId: 'TESTASSESSOR',
          dateOfBirth: '2019-12-04',
          contactDetails: {
            telephoneNumber: '12345678901', email: 'test.boi@quidos.com'
          },
          searchResultsComparisonPostcode: 'SW1A 2AA',
          qualifications: { domesticRdSap: 'ACTIVE' }
        },
        addressSummary: '2 Marsham Street, London, SW1B 2BB',
        assessmentId: '223-456',
        dateOfAssessment: '02 January 2020',
        dateRegistered: '05 January 2020',
        dateOfExpiry: '05 January 2030',
        dwellingType: 'Top floor flat',
        typeOfAssessment: 'RdSAP',
        totalFloorArea: 150,
        currentEnergyEfficiencyRating: 90,
        currentEnergyEfficiencyBand: 'b',
        potentialEnergyEfficiencyRating: 99,
        potentialEnergyEfficiencyBand: 'a',
        postcode: 'SW1B 2BB',
        addressLine1: 'Flat 33',
        addressLine2: '2 Marsham Street',
        addressLine3: '',
        addressLine4: '',
        town: 'London',
        heatDemand: {
          currentSpaceHeatingDemand: 222,
          currentWaterHeatingDemand: 321,
          impactOfLoftInsulation: 79,
          impactOfCavityInsulation: 67,
          impactOfSolidWallInsulation: 69
        }
      )
    end
  end
end
