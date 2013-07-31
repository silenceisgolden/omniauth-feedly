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
      
      option :authorize_options, [:scope, :state]
      
      option :callback_url
      
      option :token_params, {
        :grant_type => 'authorization_code',
        :state => ''
      }
      
      
      uid{ raw_info['id']}
      
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
      
      def authorize_params
        super.tap do |params|
          ["scope", "state"].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]

              # to support omniauth-oauth2's auto csrf protection
              session['omniauth.state'] = params[:state] if v == 'state'
            end
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end
    end
  end
end
    
    