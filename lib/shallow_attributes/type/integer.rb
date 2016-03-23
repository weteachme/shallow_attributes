module ShallowAttributes
  module Type
    # Abstract class for typecast object to Integer type.
    #
    # @abstract
    #
    # @since 0.1.0
    class Integer
      # Convert value to Integer type
      #
      # @private
      #
      # @param [Object] value
      # @param [Hash] object
      #
      # @example Convert sting to integer value
      #   ShallowAttributes::Type::Integer.new.coerce('2001')
      #     # => 2001
      #
      # @raise [InvalidValueError] if values is invalid
      #
      # @return [Integer]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        case value
        when nil then 0
        when ::TrueClass then 1
        when ::FalseClass then 0
        else
          value.to_i
        end
      rescue
        raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "Integer")
      end
    end
  end
end
