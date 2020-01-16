class AssessorsGatewayUnregisteredPostcodeStub
  def search(*)
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
