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
      # @param [Hash] object
      #
      # @example Convert string to float value
      #   ShallowAttributes::Type::Float.coerce('2001')
      #     # => 2001.0
      #
      # @raise [InvalidValueError] if values is invalid
      #
      # @return [Float]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        case value
        when nil then 0.0
        when ::TrueClass then 1.0
        when ::FalseClass then 0.0
        else
          value.to_f
        end
      rescue
        raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "Float")
      end
    end
  end
end
