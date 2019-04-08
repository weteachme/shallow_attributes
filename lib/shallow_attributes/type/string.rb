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
      # @param [Hash] _options
      #
      # @example Convert integer to string value
      #   ShallowAttributes::Type::String.new.coerce(2001)
      #     # => '2001'
      #
      # @return [Sting]
      #
      # @since 0.1.0
      def coerce(value, _options = {})
        case value
        when nil then options[:allow_nil] ? nil : ''
        when ::Array then value.join
        when ::Hash, ::Class then error(value)
        else
          value.respond_to?(:to_s) ? value.to_s : error(value)
        end
      end

    private

      def error(value)
        raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "String")
      end
    end
  end
end
