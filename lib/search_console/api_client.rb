require 'google/api_client'

module SearchConsole
  class ApiClient
    def self.create(oauth)
      client = Google::APIClient.new(
        application_name: 'SearchConsoleTool',
        application_version: '1.0.0'
      )
      client.authorization.client_id = oauth['client_id']
      client.authorization.client_secret = oauth['client_secret']
      client.authorization.grant_type = 'refresh_token'
      client.authorization.refresh_token = oauth['refresh_token']
      client.authorization.fetch_access_token!
      # client.authorization.scope = 'https://www.googleapis.com/auth/webmasters.readonly'
      # client.authorization.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
      # redirect_uri = client.authorization.authorization_uri
      # puts redirect_uri
      # client.authorization.code = 'PASTE CODE FOR BROWSER'
      # client.authorization.fetch_access_token
      client
    end
  end
end
