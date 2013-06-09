require 'spec_helper'

describe DisqusRails do
  %w(Posts Threads Categories Forums Users).each do |subclass|
    it "should create #{subclass} class inherited from collection class" do
      should be_const_defined(subclass)
    end
  end
end
