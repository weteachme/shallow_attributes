require 'test_helper'

class Admin
  include ShallowAttributes

  attribute :name,   String
  attribute :admin, Boolean

  alias_method :_name=, :name=
  def name=(new_name)
    custom_name = nil
    if new_name == "Godzilla"
      custom_name = "Can't tell"
    end

    self._name = custom_name || new_name
  end
end

describe ShallowAttributes do
  it 'can overrite setter' do
    user = Admin.new

    user.name = "Frank"
    user.name.must_equal 'Frank'

    user.name = "Godzilla"
    user.name.must_equal 'Can\'t tell'
  end
end
