module ShallowAttributes
  module Type
    class String
      def coerce(value)
        String(value)
      end
    end
  end
end
