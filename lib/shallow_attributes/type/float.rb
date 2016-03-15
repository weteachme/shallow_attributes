module ShallowAttributes
  module Type
    # Abstract class for typecast object to Float type.
    #
    # @abstract
    #
    # @since 0.1.0
    class Float
      # Convert value to Float type
      #
      # @private
      #
      # @param [Object] value
      #
      # @example Convert string to float value
      #   ShallowAttributes::Type::Float.new.coerce('2001')
      #     # => 2001.0
      #
      # @return [Float]
      #
      # @since 0.1.0
      def coerce(value)
        case value
        when nil then 0.0
        when ::TrueClass then 1.0
        when ::FalseClass then 0.0
        else
          value.to_f
        end
      end
    end
  end
end
