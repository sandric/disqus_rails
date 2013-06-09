module DisqusRails
  class Collection

    include Enumerable

    attr_accessor :items

    def self.inherited(subclass)
      subclass.class_exec do
        define_method "find_all_#{subclass.name.split(/::/).last.downcase}!".to_sym do
          while has_cursor_next?
            previous_items = @items
            cursor_next!
            @items = previous_items + @items
          end
          self
        end
      end
    end

    def initialize(api_class_name, method = :list, attributes = {})
      @api_class_name = api_class_name
      @method = method
      @attributes = attributes

      api_class = Api.const_get api_class_name
      results = api_class.send method, attributes
      @cursor = results[:cursor].symbolize_keys

      @items = []
      results[:response].each do |item|
        @items << DisqusRails.const_get(self.class.name.singularize.split(/::/).last).new(item)
      end
    end

    def each(&block)
      @items.each do |item|
        if block_given?
          block.call item
        else
          yield item
        end
      end
    end

    def has_cursor_next?
      @cursor[:hasNext]
    end

    def has_cursor_prev?
      @cursor[:hasPrev]
    end

    def cursor_next
      if has_cursor_next?
        @attributes[:cursor] = @cursor[:next]
        self.class.new(@api_class_name, @method, @attributes)
      end
      self
    end

    def cursor_next!
      if has_cursor_next?
        @attributes[:cursor] = @cursor[:next]
        initialize(@api_class_name, @method, @attributes)
      end
      self
    end

    def cursor_prev
      if has_cursor_prev?
        @attributes[:cursor] = @cursor[:prev]
        self.class.new(@api_class_name, @method, @attributes)
      end
      self
    end

    def cursor_prev!
      if has_cursor_prev?
        @attributes[:cursor] = @cursor[:prev]
        initialize(@api_class_name, @method, @attributes)
      end
      self
    end
  end

  %w[Posts Threads Categories Forums Users].each do |subclass|
    instance_eval "class DisqusRails::#{subclass} < DisqusRails::Collection; end"
  end
end
