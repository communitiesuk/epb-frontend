module UseCase
  class FindAssessor
    def initialize(assessors_gateway)
      @assessors_gateway = assessors_gateway
    end

    def execute(postcode)
      response = []
      #TODO: Implement assessor gateway
      #assessors = @assessors_gateway.search(postcode)

      assessors = [
        {
          "firstName": 'Gregg',
          "lastName": 'Sellen',
          "middleNames": 'Jon',
          "dateOfBirth": '2020-01-03',
          "contactDetails": {
            "telephoneNumber": '0792 102 1368', "email": 'epbassessor@epb.com'
          }
        },
        {
          "firstName": 'Juliet',
          "lastName": 'Montague',
          "middleNames": 'Will',
          "dateOfBirth": '2020-01-03',
          "contactDetails": {
            "telephoneNumber": '0792 102 1368', "email": 'epbassessor@epb.com'
          }
        }
      ]

      assessors.each do |assessor|
        response <<
          {
            fullName: "#{assessor[:firstName]} #{assessor[:lastName]}",
            distance: 0,
            accreditationScheme: 'accreditationScheme',
            schemeAssessorId: 'schemeAssessorId',
            telephoneNumber: assessor[:contactDetails][:telephoneNumber],
            email: assessor[:contactDetails][:email]
          }
      end
      response
    end
  end
end
