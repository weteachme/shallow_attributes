module ShallowAttributes
  module Types
    class Float
      def coerce(value)
        case value
        when nil then 0.0
        when TrueClass then 1.0
        when FalseClass then 0.0
        else
          Float(value)
        end
      end
    end
  end
end
