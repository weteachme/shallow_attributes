module ShallowAttributes
  # Abstract class for value classes. Provides some helper methods for
  # working with attributes.
  #
  # @abstract
  #
  # @since 0.1.0
  module InstanceMethods
    # Lambda object for gettring attributes hash for specific
    # value object.
    #
    # @private
    #
    # @since 0.1.0
    TO_H_PROC = -> (value) { value.respond_to?(:to_h) ? value.to_h : value }

    # Initialize instance object with specific attributes
    #
    # @param [Hash] attributes the attributes contained in the class
    #
    # @example Create new User instance
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String
    #   end
    #
    #   User.new(name: 'Anton') # => #<User @attributes={:name=>"Anton"}, @name="Anton">
    #
    # @return the new instance of value class with specific attributes
    #
    # @since 0.1.0
    def initialize(attributes = {})
      attributes_list = self.class.attributes
      @attributes = attributes.delete_if { |key, _| !attributes_list.include?(key) }
      define_attributes
    end

    # Returns hash of object attributes
    #
    # @example Returns all user attributs
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String
    #   end
    #
    #   user = User.new(name: 'Anton')
    #   user.attributes # => { name: "Anton" }
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def attributes
      hash = {}
      @attributes.map do |key, value|
        hash[key] =
          value.is_a?(Array) ? value.map!(&TO_H_PROC) : TO_H_PROC.call(value)
      end
      hash
    end

    # @since 0.1.0
    alias_method :to_h, :attributes

    # @since 0.1.0
    alias_method :to_hash, :attributes

    # Mass-assignment attribut values
    #
    # @example Assignment new user name
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String
    #   end
    #
    #   user = User.new(name: 'Anton')
    #   user.attributes = { name: "Ben" }
    #   user.attributes # => { name: "Ben" }
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def attributes=(attributes)
      @attributes.merge!(attributes)
      define_attributes
    end

    # Reser specific attribute to defaul value. If class included
    # `AM::Dirty`module `reset_attribute` reset change value.
    #
    # @param [Symbol] attribute the attribute which will be resete
    #
    # @example Reset name valus
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String, defauil: 'Ben'
    #   end
    #
    #   user = User.new(name: 'Anton')
    #   user.reset_attribute(:name)
    #   user.attributes # => { name: "Ben" }
    #
    # @return the last attribute value
    #
    # @since 0.1.0
    def reset_attribute(attribute)
      changed_attributes.delete(attribute.to_s) if dirty_load?
      instance_variable_set("@#{attribute}", default_value_for(attribute))
    end

    # Sets new values and returns self. Needs for embedded value.
    #
    # @private
    #
    # @param [Hash] values the new attributes for current object
    # @param [Hash] options
    #
    # @example Use embedded values
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String, defauil: 'Ben'
    #   end
    #
    #   class Post
    #     include ShallowAttributes
    #     attribute :author, User
    #   end
    #
    #   post = Post.new(author: { name: 'Anton'} )
    #   post.user.name # => 'Anton'
    #
    # @return the object
    #
    # @since 0.1.0
    def coerce(value, options = {})
      self.attributes = value
      self
    end

    # Equalate two value objects
    #
    # @param [Object] object the other object
    #
    # @example Equalate two value objects
    #   class User
    #     include ShallowAttributes
    #     attribute :name, String, defauil: 'Ben'
    #   end
    #
    #   user1 = User.new(name: 'Anton')
    #   user2 = User.new(name: 'Anton')
    #   user1 == user2 # => true
    #
    # @return [boolean]
    #
    # @since 0.1.0
    def ==(object)
      self.to_h == object.to_h
    end

  private

    # Defene attributes from `@attributes` instance value. If class
    # included `AM::Dirty`module `define_attributes` clear changes information
    #
    # @private
    #
    # @return the object
    #
    # @since 0.1.0
    def define_attributes
      @attributes.each do |name, value|
        send("#{name}=", value)
      end

      send(:clear_changes_information) if dirty_load?
    end

    # Retrns default value for specific attribute. Defaul values hash
    # takes from class getter `default_values`.
    #
    # @private
    #
    # @return [nil] if default value not defined
    # @return [Object] if default value defined
    #
    # @since 0.1.0
    def default_value_for(attribute)
      value = default_values[attribute]

      case value
      when Proc
        value.call(self, attribute)
      when Symbol, String
        self.class.method_defined?(value) ? send(value) : value
      else
        value
      end
    end

    # Returns true in ActiveModel::Dirty defined and included to
    # current value class
    #
    # @private
    #
    # @return [boolean]
    #
    # @since 0.1.0
    def dirty_load?
      @dirty_load ||=
        defined?(::ActiveModel::Dirty) && self.class.include?(::ActiveModel::Dirty)
    end

    # Returns hash of default class values
    #
    # @private
    #
    # @return [Hash]
    #
    # @since 0.1.0
    def default_values
      @default_values ||= self.class.default_values
    end
  end
end
