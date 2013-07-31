require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Feedly < OmniAuth::Strategies::OAuth2
      
      DEFAULT_SCOPE = 'https://cloud.feedly.com/subscriptions'
      
      option :name, 'feedly'
      
      option :client_options, {
        :site => 'http://sandbox.feedly.com',
        :authorize_url => '/v3/auth/auth',
        :token_url => '/v3/auth/token'
      }
      
      
      uid{ raw_info['id']}
      
      info do
        {
          :email => raw_info['email']
        }
      end
      
      credentials do
        prune!({
          'expires_in' => access_token.expires_in
        })
      end
      
      extra do
        {
          'raw_info' => raw_info
        }
      end
      
      def request_phase
        options[:authorize_params] = client_params.merge(options[:authorize_params])
        super
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, client_params.merge({
          :grant_type => 'authorization_code'}))
        end
      
      def raw_info
        @raw_info ||= access_token.get('/v3/profile').parsed
      end
      
      def client_params
        {:client_id => options[:client_id], :redirect_uri => callback_url ,:response_type => "code"}
      end
      
      # find debug point for get access token via fb, oauth2, other oauths
        
    end
  end
end

OmniAuth.config.add_camelization 'feedly', 'Feedly'
    
    