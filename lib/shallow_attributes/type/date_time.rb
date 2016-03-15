module ShallowAttributes
  module Type
    # Abstract class for typecast object to DateTime type.
    #
    # @abstract
    #
    # @since 0.1.0
    class DateTime
      # Convert value to DateTime type
      #
      # @private
      #
      # @param [Object] value
      #
      # @example Convert integer to datetime value
      #   ShallowAttributes::Type::DateTime.new.coerce('Thu Nov 29 14:33:20 GMT 2001')
      #     # => '2001-11-29T14:33:20+00:00'
      #
      # @raise [InvalidValueError] if values is not a sting
      #
      # @return [DateTime]
      #
      # @since 0.1.0
      def coerce(value)
        case value
        when ::String then ::DateTime.parse(value)
        else
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "Time")
        end
      end
    end
  end
end
