module ShallowAttributes
  module Types
    class Time
      def coerce(value)
        case value
        when ::String then ::Time.parse(value)
        when ::Integer then ::Time.at(value)
        else
          raise ShallowAttributes::Types::InvalidValueError, %(Invalid value "#{value}" for type "Time")
        end
      end
    end
  end
end
