class AssessorsGatewayNoSchemeStub
  def search(*)
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
