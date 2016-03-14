require 'shallow_attributes/types/string'
require 'shallow_attributes/types/integer'
require 'shallow_attributes/types/float'
require 'shallow_attributes/types/boolean'
require 'shallow_attributes/types/time'
require 'shallow_attributes/types/date_time'

module ShallowAttributes
  module Types
    class InvalidValueError < TypeError
    end
  end
end
