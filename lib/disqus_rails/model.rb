module Disqus
  class Model

    def self.inherited(subclass)
      subclass_name = subclass.name.split(/::/).last
      api_name = Api.const_get subclass_name.pluralize
      collection_name = DisqusRails.const_get subclass_name.pluralize

      subclass.class_exec do

        define_singleton_method :find do |id|
          new(api_name.details(subclass_name.downcase.to_sym => id)[:response])
        end

        if api_name.respond_to?(:list)
          define_singleton_method :where do |attributes={}|
            collection_name.new subclass_name.pluralize.to_sym, :list, attributes
          end
        end

        if api_name.respond_to?(:create)
          define_singleton_method :create do |attributes={}|
            subclass.new(api_name.create(attributes)[:response])
          end
        end

        define_method :reload do
          subclass.new(api_name.details(subclass_name.downcase.to_sym => self.id)[:response])
        end
      end
    end

    def initialize(attributes={})
      attributes.each do |attr_name, attr_value|
        instance_variable_set("@#{attr_name}".to_sym, attr_value)
      end
    end

    def update_attributes(attributes={})
      attributes.each do |attr_name, attr_value|
        send("#{attr_name}=", attr_value)
      end
    end
  end
end
