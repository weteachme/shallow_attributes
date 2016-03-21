module ShallowAttributes
  # Abstract class for value classes. Provides some helper methods for
  # working with class methods.
  #
  # @abstract
  #
  # @since 0.1.0
  module ClassMethods
    # Returns hash which contain default values for each attribute
    #
    # @private
    #
    # @return [Hash] hash with default values
    #
    # @since 0.1.0
    def default_values
      superclass.default_values.merge(@default_values)
    rescue NoMethodError
      @default_values
    end

    # Returns all class attributes.
    #
    #
    # @example Create new User instance
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String
    #     attribute :last_name, String
    #     attribute :age, Integer
    #   end
    #
    #   User.attributes # => [:name, :last_name, :age]
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def attributes
      default_values.keys
    end

    # Define attribute with specific type and default value
    # for current class.
    #
    # @param [String, Symbol] name the attribute name
    # @param [String, Symbol] type the type of attribute
    # @param [hash] options the attribute options
    # @option options [Object] :default default value for attribute
    # @option options [Class] :of class of array elems
    #
    # @example Create new User instance
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String, default: 'Anton'
    #   end
    #
    #   User.new              # => #<User @attributes={:name=>"Anton"}, @name="Anton">
    #   User.new(name: 'ben') # => #<User @attributes={:name=>"Ben"}, @name="Ben">
    #
    # @return [Object]
    #
    # @since 0.1.0
    def attribute(name, type, options = {})
      options[:default] ||= [] if type == Array

      @default_values ||= {}
      @default_values[name] = options.delete(:default)

      initialize_setter(name, type, options)
      initialize_getter(name)
      initialize_modules(name)
    end

    private

    # Define setter method for each attribute.
    #
    # @private
    #
    # @param [String, Symbol] name the attribute name
    # @param [String, Symbol] type the type of attribute
    # @param [hash] options the attribute options
    #
    # @return [Object]
    #
    # @since 0.1.0
    def initialize_setter(name, type, options)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}=(value)
          @attributes[:#{name}] =
            ShallowAttributes::Type.coerce(#{type}, value, #{options})

          if dirty_load?
            #{name}_will_change! unless @#{name} == @attributes[:#{name}]
          end

          @#{name} = @attributes[:#{name}]
        end
      EOS
    end

    # Define getter method for each attribute.
    #
    # @private
    #
    # @param [String, Symbol] name the attribute name
    #
    # @return [Object]
    #
    # @since 0.1.0
    def initialize_getter(name)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}
          @#{name}
        end
      EOS
    end

    # Define `define_attribute_method` method for each attribute
    # if AM::Dirty defined and included to current class.
    #
    # @private
    #
    # @param [String, Symbol] name the attribute name
    #
    # @return [Object]
    #
    # @since 0.1.0
    def initialize_modules(name)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        if defined?(::ActiveModel::Dirty) && include?(::ActiveModel::Dirty)
          define_attribute_method :#{name}
        end
      EOS
    end
  end
end
