module ShallowAttributes
  module ClassMethods
    attr_reader :default_values

    def attribute(name, type, options = {})
      options[:default] ||= [] if type == Array

      @default_values ||= {}
      @default_values[name] = options.delete(:default)

      initialize_setter(name, type, options)
      initialize_getter(name)
      initialize_modules(name)
    end

    private

    def initialize_setter(name, type, options)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}=(value)
          @attributes[:#{name}] =
            ShallowAttributes::Type.coerce(#{type}, value, #{options})

          if include_dirty?
            #{name}_will_change! unless @#{name} == @attributes[:#{name}]
          end

          @#{name} = @attributes[:#{name}]
        end
      EOS
    end

    def initialize_getter(name)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} || default_value_for(#{name.inspect})
        end
      EOS
    end

    def initialize_modules(name)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        if defined?(::ActiveModel::Dirty) && include?(::ActiveModel::Dirty)
          define_attribute_method :#{name}
        end
      EOS
    end
  end
end
