module ShallowAttributes
  module Types
    class Array
      def coerce(values, element_class)
        unless values.is_a? ::Array
          raise ShallowAttributes::Types::InvalidValueError, %(Invalid value "#{values}" for type "Array")
        end

        values.map! { |value| ShallowAttributes::Types.coerce(element_class, value) }
      end
    end
  end
end
