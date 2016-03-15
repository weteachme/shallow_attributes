require 'shallow_attributes/type/array'
require 'shallow_attributes/type/boolean'
require 'shallow_attributes/type/date_time'
require 'shallow_attributes/type/float'
require 'shallow_attributes/type/integer'
require 'shallow_attributes/type/string'
require 'shallow_attributes/type/time'

module ShallowAttributes
  # Namespace for standart type classes
  #
  # @since 0.1.0
  module Type
    # Error class for ivalid value types
    #
    # @since 0.1.0
    class InvalidValueError < TypeError
    end

    # Convert value object to specific Type class
    #
    # @private
    #
    # @param [Class] type the type class object
    # @param [Object] value the value that should be submit to the necessary type
    # @param [Hash] options the options to create a message with.
    # @option opts [String] :of The type of array
    #
    # @example Convert integer to sting type
    #   ShallowAttributes::Type.coerce(String, 1)
    #     # => '1'
    #
    # @example Convert string to custom hash type
    #   ShallowAttributes::Type.instance_for(JsonType, '{"a"=>1}')
    #     # => { a: 1 }
    #
    # @return the converted value object
    #
    # @since 0.1.0
    def self.coerce(type, value, options = {})
      if type == ::Array
        instance_for(type).coerce(value, options[:of])
      else
        instance_for(type).coerce(value)
      end
    end

  private

    # Returns instans object for specific Type class
    #
    # @private
    #
    # @param [Class] type the type class object
    #
    # @example Returns Sting type class
    #   ShallowAttributes::Type.instance_for(String)
    #     # => ShallowAttributes::Type::Sting instance
    #
    # @example Returns other type class
    #   ShallowAttributes::Type.instance_for(MySpecialStringType)
    #     # => MySpecialStringType instance
    #
    # @return the type object
    #
    # @since 0.1.0
    def self.instance_for(type)
      Object.const_get("ShallowAttributes::Type::#{type}").new
    end
  end
end
