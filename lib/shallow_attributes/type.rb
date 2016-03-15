require 'shallow_attributes/type/array'
require 'shallow_attributes/type/boolean'
require 'shallow_attributes/type/date_time'
require 'shallow_attributes/type/float'
require 'shallow_attributes/type/integer'
require 'shallow_attributes/type/string'
require 'shallow_attributes/type/time'

module ShallowAttributes
  module Type
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
      Object.const_get("ShallowAttributes::Type::#{type}").new
    end
  end
end
