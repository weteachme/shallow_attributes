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
      #
      # @example Convert sting to integer value
      #   ShallowAttributes::Type::Integer.new.coerce('2001')
      #     # => 2001
      #
      # @return [Integer]
      #
      # @since 0.1.0
      def coerce(value)
        case value
        when nil then 0
        when ::TrueClass then 1
        when ::FalseClass then 0
        else
          value.to_i
        end
      end
    end
  end
end
