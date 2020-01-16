# frozen_string_literal: true

WebMock.stub_request(
  :post, 'http://test-auth-server.gov.uk/oauth/token'
).with(
  body: {
    client_id: 'test.id',
    client_secret: 'test.client.secret',
    grant_type: 'client_credentials'
  },
  headers: {
    Accept: '*/*',
    'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Content-Type' => 'application/x-www-form-urlencoded',
    'User-Agent' => 'Faraday v1.0.0'
  }
).to_return(
  status: 200,
  body: {
    access_token: 'abc', expires_in: 3_600, token_type: 'bearer'
  }.to_json,
  headers: { 'Content-Type' => 'application/json' }
)
