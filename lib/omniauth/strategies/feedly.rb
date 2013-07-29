require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Feedly < OmniAuth::Strategies::OAuth2
      
      option :name, "feedly"
      
      option :client_options, {
        :site => 'http://cloud.feedly.com',
        :authorize_url => '/v3/auth/auth',
        :token_url => '/v3/auth/token'
      }
      
      feedly_code{ raw_info['id']}
      
      info do
        {
          :email => raw_info['email']
        }
      end
      
      extra do
        {
          'raw_info' => raw_info
        }
      end
      
      def raw_info
        @raw_info ||= access_token.get('/v3/profile').parsed
      end
    end
  end
end
    
    