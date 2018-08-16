require 'faraday_middleware'
require 'faraday/response/raise_http_4xx'
require 'faraday/response/raise_http_5xx'

module Genability
  # @private
  module Connection
    private

    def connection(raw=false)
      # raise if id or key is missing
      options = {
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => endpoint
      }

      Faraday::Connection.new(options) do |connection|
        connection.basic_auth application_id, application_key
        connection.headers['Accept'] = "application/#{format}; charset=utf-8"
        connection.headers['User-Agent'] = user_agent
        connection.request :json
        connection.request :multipart
        connection.response :mashify unless raw
        connection.response :logger if debug_logging
        unless raw
          case format.to_s.downcase
          when 'json'
            connection.response :json, :content_type => /\bjson$/
          end
        end
        connection.use Faraday::Response::RaiseHttp4xx
        connection.use Faraday::Response::RaiseHttp5xx
        connection.adapter adapter
      end
    end
  end
end

