require 'shallow_attributes/types/string'
require 'shallow_attributes/types/integer'
require 'shallow_attributes/types/float'
require 'shallow_attributes/types/boolean'
require 'shallow_attributes/types/time'
require 'shallow_attributes/types/date_time'
require 'shallow_attributes/types/array'

module ShallowAttributes
  module Types
    class InvalidValueError < TypeError
    end

    def self.coerce(type, value, options = {})
      if type == ::Array
        type_instance(type).coerce(value, options[:of])
      else
        type_instance(type).coerce(value)
      end
    end

  private

    def self.type_instance(type)
      Object.const_get("ShallowAttributes::Types::#{type}").new
    end
  end
end
