module ShallowAttributes
  module Type
    # Abstract class for typecast object to String type.
    #
    # @abstract
    #
    # @since 0.1.0
    class String
      # Convert value to String type
      #
      # @private
      #
      # @param [Object] value
      # @param [Hash] object
      #
      # @example Convert intger to string value
      #   ShallowAttributes::Type::String.coerce(2001)
      #     # => '2001'
      #
      # @return [Sting]
      #
      # @since 0.1.0
      def coerce(value, options = {})
        value.to_s
      end
    end
  end
end
