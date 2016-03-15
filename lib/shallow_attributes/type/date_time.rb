module ShallowAttributes
  module Type
    class DateTime
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
