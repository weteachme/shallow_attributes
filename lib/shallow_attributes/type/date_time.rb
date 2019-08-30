require 'date'

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
      # @param [Hash] _options
      #
      # @example Convert integer to datetime value
      #   ShallowAttributes::Type::DateTime.new.coerce('Thu Nov 29 14:33:20 GMT 2001')
      #     # => '2001-11-29T14:33:20+00:00'
      #
      # @raise [InvalidValueError] if value is not a string
      #
      # @return [DateTime]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        case value
        when ::DateTime then value
        when ::Time then ::DateTime.parse(value.to_s)
        else
          ::DateTime.parse(value)
        end
      rescue
        if options.fetch(:strict, true)
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "DateTime")
        else
          nil
        end
      end
    end
  end
end
