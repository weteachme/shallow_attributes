module ShallowAttributes
  module ClassMethods
    def attribute(name, type, options = {})
      options[:default] ||= [] if type == Array

      @default_values ||= {}
      @default_values[name] = options.delete(:default)

      initialie_setter(name, type, options)
      initialie_getter(name)
    end

    def default_values
      @default_values
    end

    private

    def initialie_setter(name, type, options)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}=(value)
          @attributes[:#{name}] = ShallowAttributes::Type.coerce(#{type}, value, #{options})
          @#{name} = @attributes[:#{name}]
        end
      EOS
    end

    def initialie_getter(name)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} || default_value_for(#{name.inspect})
        end
      EOS
    end
  end
end
