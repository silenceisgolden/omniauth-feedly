require 'omniauth/strategies/oauth2'
require 'base64'
require 'openssl'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Feedly < OmniAuth::Strategies::OAuth2
      
      DEFAULT_SCOPE = 'https://cloud.feedly.com/subscriptions'
      DEFAULT_RESPONSE_TYPE = 'code'
      
      option :client_options, {
        :site => 'http://cloud.feedly.com',
        :authorize_url => '/v3/auth/auth',
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
      
      extra do
        {:raw_info => raw_info}
      end
      
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
      
      def request_phase
        if signed_request_contains_access_token?
          params = { :signed_request => raw_signed_request }
          params[:state] = request.params['state'] if request.params['state']
          query = Rack::Utils.build_query(params)
          
          url = callback_url
          url << "?" unless url.match(/\?/)
          url << "&" unless url.match(/[\&\?]$/)
          url << query
          
          redirect url
        else
          super
        end
      end
      
      def callback_url
        if @authorization_code_from_signed_request
          ''
        else
          options[:callback_url] || super
        end
      end
      
      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end
      
      def base64_decode_url(value)
        value += '=' * (4 - value.size.modulo(4))
        Base64.decode64(value.tr('-_', '+/'))
      end
    end
  end
end
    
    