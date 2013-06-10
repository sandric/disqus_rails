require 'json'
require 'base64'

module DisqusRails
  module Helpers

    def disqus_init(attributes={})
      if attributes.has_key?(:short_name)
        DisqusRails.const_set('SHORT_NAME', attributes[:short_name])
      else
        attributes[:short_name] = DisqusRails::SHORT_NAME
      end

      if attributes.has_key?(:public_key)
        DisqusRails.const_set('PUBLIC_KEY', attributes[:public_key])
      else
        attributes[:public_key] = DisqusRails::PUBLIC_KEY
      end

      if attributes.has_key?(:secret_key)
        DisqusRails.const_set('SECRET_KEY', attributes[:secret_key])
      end

      if attributes.has_key?(:access_token)
        DisqusRails.const_set('ACCESS_TOKEN', attributes[:access_token])
      end

      if attributes.has_key?(:disquser) && attributes[:disquser].respond_to?(:disqus_params)
        attributes[:remote_auth_s3] = disqus_sso_script attributes[:disquser].disqus_params()
      end

      attributes.delete :disquser
      attributes.delete :secret_key
      attributes.delete :access_token

      javascript_tag %Q"$(document).ready(function(){
                          window.disqus_rails = new DisqusRails(#{attributes.to_json});
                        });"
    end


    def disqus_sso_script(disquser)
       # encode the data to base64
      message = Base64.strict_encode64(disquser.to_json)

      # generate a timestamp for signing the message
      timestamp = Time.now.to_i

      # generate our hmac signature
      digest  = OpenSSL::Digest::Digest.new('sha1')
      signature = OpenSSL::HMAC.hexdigest(digest, SECRET_KEY, "#{message} #{timestamp}")

      # return a script tag to insert the sso message
      "#{message} #{signature} #{timestamp}"
    end


    def disqus_thread(disqusable_id=nil, disqusable_title=nil)
      javascript_tag %Q"$(document).ready(function(){
                          disqus_rails.draw_thread(\"#{disqusable_id}\", \"#{disqusable_title}\");
                        });"
    end
  end
end
