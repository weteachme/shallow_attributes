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
        instance_for(type).coerce(value, options[:of])
      else
        instance_for(type).coerce(value)
      end
    end

  private

    def self.instance_for(type)
      Object.const_get("ShallowAttributes::Type::#{type}").new
    end
  end
end
