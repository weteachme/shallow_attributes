module ShallowAttributes
  module Type
    # Abstract class for typecast object to String type.
    #
    # @abstract
    #
    # @since 0.1.0
    class String
      # Convert value to String type
      #
      # @private
      #
      # @param [Object] value
      # @param [Hash] object
      #
      # @example Convert intger to string value
      #   ShallowAttributes::Type::String.coerce(2001)
      #     # => '2001'
      #
      # @return [Sting]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        case value
        when ::Array then value.join
        when ::Hash then error(value)
        else
          value.to_s
        end
      end

    private

      def error(value)
        raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "String")
      end
    end
  end
end
