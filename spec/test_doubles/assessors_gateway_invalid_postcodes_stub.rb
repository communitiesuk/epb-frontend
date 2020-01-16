class AssessorsGatewayInvalidPostcodesStub
  def search(*)
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
