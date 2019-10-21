module ShallowAttributes
  module Type
    # Abstract class for typecast object to Date type.
    #
    # @abstract
    #
    # @since 0.1.0
    class Date
      # Convert value to Date type
      #
      # @private
      #
      # @param [Object] value
      # @param [Hash] _options
      #
      # @example Convert string to Date value
      #   ShallowAttributes::Type::Date.new.coerce('Thu Nov 29 2001')
      #     # => #<Date: 2001-11-29 ((2452243j,0s,0n),+0s,2299161j)>
      #
      # @raise [InvalidValueError] if value is not a string
      #
      # @return [Date]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        case value
        when ::DateTime, ::Time then value.to_date
        when ::Date then value
        else
          # TODO: ::Date.parse(Class.new.to_s) valid call and will create strange Data object
          ::Date.parse(value.to_s)
        end
      rescue
        if options.fetch(:strict, true)
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "Date")
        else
          nil
        end
      end
    end
  end
end
