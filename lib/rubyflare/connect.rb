module Rubyflare
  class Connect

    attr_reader :response

    API_URL = "https://api.cloudflare.com/client/v4/"

    def initialize(email, api_key)
      @email = email
      @api_key = api_key
    end
    
    %i(get post put patch delete).each do |method_name|
      define_method(method_name) do |endpoint, options = {}|
        response= if method_name == :get
                    RestClient.get(API_URL + endpoint, request_headers)
                  else
                    options = options.to_json unless method_name == :get
                    RestClient.send(method_name, API_URL + endpoint, options, request_headers)
                  end
        
        @response = Rubyflare::Response.new(method_name, endpoint, response)
      end
    end

    def request_headers
      Hash.new.tap do |headers|
        headers['X-Auth-Email'] = @email
        headers['X-Auth-Key'] = @api_key
        headers['Content-Type'] = 'application/json'
      end
    end
  end
end


