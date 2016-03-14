require 'shallow_attributes/version'
require 'shallow_attributes/types'

module ShallowAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def attribute(name, type, options = {})
      attr_reader name

      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}=(value)
          @#{name} = ShallowAttributes::Types.coerce(#{type}, value)
        end
      EOS
    end
  end

  def initialize(attributes = {})
    @attributes = attributes
    define_attributes
  end

  def attributes
    @attributes
  end

  def attributes=(attributes)
    @attributes.merge!(attributes)
    define_attributes
  end
  
  private

  def define_attributes
    @attributes.each do |name, value|
      self.send("#{name}=", value)
    end
  end
end
