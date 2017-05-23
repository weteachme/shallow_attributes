module ShallowAttributes
  module Type
    # Abstract class for typecast object to Array type.
    #
    # @abstract
    #
    # @since 0.1.0
    class Array
      # Convert value to Array type
      #
      # @private
      #
      # @param [Array] values
      # @param [Hash] options
      # @option options [String] :of the type of array element class
      #
      # @example Convert integer array to string array
      #   ShallowAttributes::Type::Array.new.coerce([1, 2], String)
      #     # => ['1', '2']
      #
      # @raise [InvalidValueError] if values is not Array
      #
      # @return [Array]
      #
      # @since 0.1.0
      def coerce(values, options = {})
        unless values.is_a? ::Array
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{values}" for type "Array")
        end
        values.map! do |value|
          ShallowAttributes::Type.coerce(item_klass(options[:of]), value)
        end
      end

      private

      def item_klass(klass)
        return klass unless klass.is_a? ::String
        Object.const_get(klass)
      end
    end
  end
end
