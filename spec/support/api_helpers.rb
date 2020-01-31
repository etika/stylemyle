module ApiHelpers
  def token_for(username, password)
    post '/oauth/token', params: { username: username, password: password, grant_type: 'password' }
    json_res = JSON.parse(response.body)
    json_res['access_token']
  end

  def api_request_post(url, token:, params: {})
    post("/api/v1/#{url}", headers: headers(token), params: params.to_json)
  end

  def api_request_get(url, token:, params: {})
    get("/api/v1/#{url}", headers: headers(token), params: params)
  end

  def api_request_put(url, token:, params: {})
    put("/api/v1/#{url}", headers: headers(token), params: params.to_json)
  end

  def api_request_delete(url, token:)
    delete("/api/v1/#{url}", headers: headers(token))
  end

  def headers(token)
    { 'Content-Type': 'application/json',
      'Authorization': "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include ApiHelpers
end
