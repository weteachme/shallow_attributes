require 'shallow_attributes/version'
require 'shallow_attributes/types'

module ShallowAttributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attribute(name, type, options = {})
      options[:default] ||= [] if type == Array

      @default_values ||= {}
      @default_values[name] = options.delete(:default)

      initialie_setter(name, type, options)
      initialie_getter(name)
    end

    def default_values
      @default_values
    end

    private

    def initialie_setter(name, type, options)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}=(value)
          @attributes[:#{name}] = ShallowAttributes::Types.coerce(#{type}, value, #{options})
          @#{name} = @attributes[:#{name}]
        end
      EOS
    end

    def initialie_getter(name)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}
          @#{name} || default_value_for(#{name.inspect})
        end
      EOS
    end
  end

  def initialize(attributes = {})
    @attributes = attributes
    define_attributes
  end

  def attributes
    hash = {}
    @attributes.map do |key, value|
      hash[key] =
        value.is_a?(Array) ? value.map(&call_attributes) : call_attributes.call(value)
    end
    hash
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

  def call_attributes
    -> (value) { value.respond_to?(:attributes) ? value.attributes : value }
  end

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
