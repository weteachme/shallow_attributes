module ShallowAttributes
  module Type
    # Abstract class for typecast object to Boolean type.
    #
    # @abstract
    #
    # @since 0.1.0
    class Boolean
      # Array of true values
      #
      # @private
      #
      # @since 0.1.0
      TRUE_VALUES  = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].freeze

      # Array of false values
      #
      # @private
      #
      # @since 0.1.0
      FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', nil].freeze

      # Convert value to Boolean type
      #
      # @private
      #
      # @param [Object] value
      # @param [Hash] option
      #
      # @example Convert integer to boolean value
      #   ShallowAttributes::Type::Boolean.new.coerce(1)
      #     # => true
      #
      #   ShallowAttributes::Type::Boolean.new.coerce(0)
      #     # => false
      #
      # @raise [InvalidValueError] if values is not included in true and false arrays
      #
      # @return [boolean]
      #
      # @since 0.1.0
      def coerce(value, _options = {})
        if TRUE_VALUES.include?(value)
          true
        elsif FALSE_VALUES.include?(value)
          false
        else
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "Boolean")
        end
      end
    end
  end
end
