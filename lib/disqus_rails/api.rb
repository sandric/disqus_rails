require 'open-uri'
require 'json'
require 'net/http'
require 'uri'
require 'yaml'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

module DisqusRails
  module Api
    requests = ActiveSupport::HashWithIndifferentAccess.new YAML::load(File.open(File.join(File.dirname(__FILE__), "api.yml", file)))

    requests.each do |section_name, section|
      const = const_set(section_name, Class.new)

      section.each do |method_name, method|
        const.define_singleton_method(method_name) do |*arguments|
          arguments[0] ||= {}

          method[:params][:required].each do |required_method_name|
            unless arguments[0].has_key?(required_method_name.to_sym)
              raise "Required parameter '#{required_method_name}' not passed to Disqus::Api::#{section_name}.#{method_name}"
            end
          end

          unless (unknown_params = arguments[0].stringify_keys!.keys - (method[:params][:required] + method[:params][:optional])).empty?
            raise "Unknown #{"param".pluralize unknown_params.size} '#{unknown_params.join " "}' passed to Disqus::Api::#{section_name}.#{method_name}"
          end

          arguments[0][:api_key] = PUBLIC_KEY
          if method[:requires_authentication]
            arguments[0][:access_token] = ACCESS_TOKEN
          end
          response = Disqus::Api.send method[:method].downcase, arguments[0], method[:url]

          arguments[0].delete(:api_key)
          arguments[0].delete(:access_token)

          response
        end
      end
    end

    class << self

      def parse_response(response)
        if response[:code] > 0
          raise "Error, Disqus responsed with code #{response[:code]} - #{response[:response]}"
        else
          response.delete(:code)
          response
        end
      end

      def get(args, url)
        populated_url = url + '?'
        args.each{ |k, v| populated_url += "#{k}=#{v}&" }
        url.chomp('&')

        parse_response JSON.parse( open(populated_url){ |u| u.read } ).symbolize_keys
      end

      def post(args, url)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request.add_field('Content-Type', 'application/json')
        params_string = args.inject(""){|params_string, (param_name, param_value)| params_string += "#{param_name}=#{param_value}&" }
        request.body = params_string

        parse_response JSON.parse(http.request(request).body).symbolize_keys
      end

    end
  end
end
