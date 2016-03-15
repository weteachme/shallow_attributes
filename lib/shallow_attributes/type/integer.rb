module ShallowAttributes
  module Type
    class Integer
      def coerce(value)
        case value
        when nil then 0
        when TrueClass then 1
        when FalseClass then 0
        else
          Integer(value)
        end
      end
    end
  end
end
