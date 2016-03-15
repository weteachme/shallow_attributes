module ShallowAttributes
  module Type
    class Array
      def coerce(values, element_class)
        unless values.is_a? ::Array
          raise ShallowAttributes::Type::InvalidValueError, %(Invalid value "#{values}" for type "Array")
        end

        values.map! { |value| ShallowAttributes::Type.coerce(element_class, value) }
      end
    end
  end
end
