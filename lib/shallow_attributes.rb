require 'shallow_attributes/version'
require 'shallow_attributes/types'

module ShallowAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attribute(name, type, options = {})
      @default_values ||= {}
      @default_values[name] = options[:default]

      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}=(value)
          @#{name} = ShallowAttributes::Types.coerce(#{type}, value)
        end
      EOS

      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} || default_value_for(#{name.inspect})
        end
      EOS
    end

    def default_values
      @default_values
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

  def reset_attribute(attribute)
    remove_instance_variable("@#{attribute}")
  end

  def coerce(values)
    self.attributes = values
    self
  end

  private

  def define_attributes
    @attributes.each do |name, value|
      self.send("#{name}=", value)
    end
  end

  def default_value_for(attribute)
    value = self.class.default_values[attribute]

    case value
    when Proc
      value.call(self, attribute)
    when Symbol, String
      self.class.method_defined?(value) ? send(value) : value
    else
      value
    end
  end
end
