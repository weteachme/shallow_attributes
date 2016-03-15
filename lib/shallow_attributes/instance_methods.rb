module ShallowAttributes
  # Abstract class for value classes. Provides some helper methods for
  # working with attributes.
  #
  # @abstract
  #
  # @since 0.1.0
  module InstanceMethods
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
      @attributes = attributes
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
          value.is_a?(Array) ? value.map(&to_h_proc) : to_h_proc.call(value)
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
      remove_instance_variable("@#{attribute}")
    end

    # Sets new values and returns self. Needs for embedded value.
    #
    # @private
    #
    # @param [Hash] attributes the new attributes for current object
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
    def coerce(values)
      self.attributes = values
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

      send(:clear_changes_information) if include_dirty?
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

    # Retrns lambda object for gettring attributes hash for specific
    # value object.
    #
    # @private
    #
    # @return [proc]
    #
    # for block {|value| ... }
    #
    # @yieldparam [value] value the value object
    # @yieldreturn [Hash] attributes hash for specific value object
    #
    # @since 0.1.0
    def to_h_proc
      -> (value) { value.respond_to?(:to_h) ? value.to_h : value }
    end

    # Returns true in ActiveModel::Dirty defined and included to
    # current value class
    #
    # @private
    #
    # @return [boolean]
    #
    # @since 0.1.0
    def include_dirty?
      defined?(::ActiveModel::Dirty) && self.class.include?(::ActiveModel::Dirty)
    end
  end
end
