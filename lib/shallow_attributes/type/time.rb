module ShallowAttributes
  module Type
    # Abstract class for typecast object to Time type.
    #
    # @abstract
    #
    # @since 0.1.0
    class Time
      # Convert value to Time type
      #
      # @private
      #
      # @param [Object] value
      # @param [Hash] object
      #
      # @example Convert string to Time value
      #   ShallowAttributes::Type::Time.coerce('Thu Nov 29 14:33:20 GMT 2001')
      #     # => '2001-11-29 14:33:20 +0000'
      #
      # @raise [InvalidValueError] if values is not a sting or integer
      #
      # @return [Time]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        case value
        when ::Time then value
        when ::Integer then ::Time.at(value)
        else
          ::Time.parse(value.to_s)
        end
      rescue
        raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "DateTime")
      end
    end
  end
end
