module UseCase
  class FindAssessor
    def initialize(assessors_gateway)
      @assessors_gateway = assessors_gateway
    end

    def execute(postcode)
      response = []

      assessors = @assessors_gateway.search('SW1A+2AA')[:results]

      assessors.each do |assessors_details|
        assessor = assessors_details[:assessor]
        response <<
          {
            fullName: "#{assessor[:firstName]} #{assessor[:lastName]}",
            distance: assessors_details[:distanceFromPostcodeInMiles],
            accreditationScheme: assessor[:registeredBy][:name],
            schemeAssessorId: assessor[:registeredBy][:schemeId],
            telephoneNumber: assessor[:contactDetails][:telephoneNumber],
            email: assessor[:contactDetails][:email]
          }
      end

      response
    end
  end
end
