module ShallowAttributes
  module Type
    class Time
      def coerce(value)
        case value
        when ::String then ::Time.parse(value)
        when ::Integer then ::Time.at(value)
        else
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{value}" for type "Time")
        end
      end
    end
  end
end
