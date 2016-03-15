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
          value.is_a?(Array) ? value.map(&to_h_proc) : to_h_proc.call(value)
      end
      hash
    end
    alias_method :to_h, :attributes
    alias_method :to_hash, :attributes

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

    def ==(object)
      self.to_h == object.to_h
    end

  private

    def define_attributes
      @attributes.each do |name, value|
        send("#{name}=", value)
      end

      send(:clear_changes_information) if include_dirty?
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

    def to_h_proc
      -> (value) { value.respond_to?(:to_h) ? value.to_h : value }
    end

    def include_dirty?
      defined?(::ActiveModel::Dirty) && self.class.include?(::ActiveModel::Dirty)
    end
  end
end
