module ShallowAttributes
  module Types
    class String
      def coerce(value)
        String(value)
      end
    end
  end
end
