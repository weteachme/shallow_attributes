module ShallowAttributes
  module Types
    class DateTime
      def coerce(value)
        case value
        when ::String then ::DateTime.parse(value)
        else
          raise ShallowAttributes::Types::InvalidValueError, %(Invalid value "#{value}" for type "Time")
        end
      end
    end
  end
end
