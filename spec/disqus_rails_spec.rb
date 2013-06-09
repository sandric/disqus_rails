require 'spec_helper'

describe DisqusRails do

  before :all do
    DisqusRails.setup do |config|
      config::SHORT_NAME = "stubbed_short_name"
      config::SECRET_KEY = "stubbed_secret_key"
      config::PUBLIC_KEY = "stubbed_public_key"
      config::ACCESS_TOKEN = "stubbed_access_token"
    end
  end

  %w(SHORT_NAME SECRET_KEY PUBLIC_KEY ACCESS_TOKEN).each do |config_const|
    it { should be_const_defined config_const }
  end
end
