require 'spec_helper'

describe DisqusRails::Model do
  %w(Category Forum Post Thread User).each do |klass|
    it "should create singleton method find in #{klass} class" do
      klass_instance = DisqusRails.const_get(klass).new()
      klass_instance.singleton_class.should respond_to(:find)
    end

    it "should create singleton method where if #{klass} api class has list method" do
      if DisqusRails::Api.const_get(klass.pluralize).respond_to?(:list)
        klass_instance = DisqusRails.const_get(klass).new()
        klass_instance.singleton_class.should respond_to(:where)
      end
    end

    %w(update_attributes reload).each do |method|
      it "should create method #{method} in #{klass} class" do
        klass_instance = DisqusRails.const_get(klass).new()
        klass_instance.should respond_to(method)
      end
    end
  end
end
