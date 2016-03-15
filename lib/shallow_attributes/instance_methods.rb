module ShallowAttributes
  module InstanceMethods
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

      if self.class.include? ActiveModel::Dirty
        self.send(:clear_changes_information)
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
end
