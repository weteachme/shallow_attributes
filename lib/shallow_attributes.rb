require 'shallow_attributes/class_methods'
require 'shallow_attributes/instance_methods'
require 'shallow_attributes/type'
require 'shallow_attributes/version'

module ShallowAttributes
  include InstanceMethods

  def self.included(base)
    base.extend(ClassMethods)
  end
end
