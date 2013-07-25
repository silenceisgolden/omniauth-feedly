require 'omniauth/strategies/oauth2'
require 'base64'
require 'openssl'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Feedly < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError; end
      
      DEFAULT_SCOPE = 'https://cloud.feedly.com/subscriptions'
      DEFAULT_RESPONSE_TYPE = 'code'
      
      option :client_options, {
        :site => 'http://cloud.feedly.com',
        :authorize_url => 'http://cloud.feedly.com/v3/auth/auth',
        :token_url => '/v3/auth/token'
      }
      
      option :token_params, {
        :parse => :query
      }
      
      option :acess_token_options, {
        :header_format => 'OAuth %s',
        :param_name => 'access_token'
      }
      
      option :authorize_options [:response_type, :scope]
      
      code {raw_info['code']}
      
      def raw_info
        @raw_info ||= access_token.post('/v3/auth/token', info_options).parsed || {}
      end
      
      def info_options
        options[:info_fields] ? {:params => {:fields => options[:info_fields]}} : {}
      end
      
      def build_access_token
        if access_token = request.params["access_token"]
          ::OAuth2::AccessToken.from_hash(
            client,
            {"access_token" => access_token}.update(access_token_options)
          )
      elsif signed_request_contains_access_token?
        hash = signed_request.clone
        ::OAuth2::AccessToken.new(
          client,
          hash.delete('oauth_token'),
          hash.merge!(access_token_options.merge(:expires_at => hash.delete('expires')))
        )
      else
        with_authorization_code! {super}.tap do |token|
          token.options.merge!(access_token_options)
        end
      end
    end
  end
end
    
    