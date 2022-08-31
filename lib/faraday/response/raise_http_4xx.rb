require 'faraday'
require 'hashie'

# @private
module Faraday
  # @private
  class Response::RaiseHttp4xx < Faraday::Middleware

    def on_complete(env)
      case env[:status].to_i
      when 400
        raise Genability::BadRequest, error_message(env)
      when 401
        raise Genability::Unauthorized, error_message(env)
      when 403
        raise Genability::Forbidden, error_message(env)
      when 404
        raise Genability::NotFound, error_message(env)
      end
    end

    private

    def error_message(env)
      "#{env[:method].to_s.upcase} #{env[:url].to_s} STATUS:#{env[:status]} #{error_body(env[:body])}"
    end

    def error_body(body)
      if body.nil?
        nil
      else
        body = JSON.parse(body) if body.is_a?(String)
        "ERRORS:#{body["results"].count}#{error_details(body)}"
      end
    end

    def error_details(body)
      msg = ""
      body = Hashie::Mash.new(body) if !body.is_a?(Hashie::Mash)
      body.results.each_with_index do |result, i|
        msg << " #{i+1}[code:#{result.code} object_name:#{result.objectName} property_name:#{result.propertyName} message:#{result.message}]"
      end
      msg
    end


  end
end

