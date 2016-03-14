module ShallowAttributes
  module Types
    class Boolean
      TRUE_VALUES  = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON']
      FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', nil]

      def coerce(value)
        if TRUE_VALUES.include?(value)
          true
        elsif FALSE_VALUES.include?(value)
          false
        else
          raise ShallowAttributes::Types::InvalidValueError, %(Invalid value "#{value}" for type "Boolean")
        end
      end
    end
  end
end
