require 'shallow_attributes/class_methods'
require 'shallow_attributes/instance_methods'
require 'shallow_attributes/type'
require 'shallow_attributes/version'

# Main module
#
# @since 0.1.0
module ShallowAttributes
  include InstanceMethods

  # Error class for mandatory arguments that were not provided
  #
  # @since 0.10.0
  class MissingAttributeError < TypeError; end

  # Including ShallowAttributes class methods to specific class
  #
  # @private
  #
  # @param [Class] base the class containing class methods
  #
  # @return [Class] class for including ShallowAttributes gem
  #
  # @since 0.1.0
  def self.included(base)
    base.extend(ClassMethods)
  end
end

# Boolean class for working with bool values
#
# @private
#
# @since 0.1.0
class Boolean; end
