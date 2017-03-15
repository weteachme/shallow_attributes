require 'test_helper'

# Base class mixes in ShallowAttributes and defines attributes
class BaseUser
  include ShallowAttributes

  attribute :name, String
  attribute :role, String
end

class Moderator < BaseUser
  include ShallowAttributes

  attribute :rates, Array, of: Integer
end

class Admin < BaseUser
  include ShallowAttributes

  attribute :role, Integer
  attribute :last_name, String
end

# Base class mixes in ShallowAttributes, but does not define attributes
class Base1
  include ShallowAttributes
end

class Sub1 < Base1
  attribute :email, String
end

# Base class does not mix in ShallowAttributes
class Base2
end

class Sub2 < Base2
  include ShallowAttributes

  attribute :email, String
end

describe ShallowAttributes do
  describe '::attributes' do
    describe 'for inheritance' do
      it 'returns array of all attributes' do
        Moderator.attributes.must_equal(%i(name role rates))
      end
    end
  end

  describe 'with inheritance from class that mixes in ShallowAttributes and defines attributes' do
    let(:params) { { name: 'Anton', role: 'moderator', last_name: 'New', rates: [1, 2, 3] } }
    let(:moderator) { Moderator.new(params) }
    let(:admin) { Admin.new(params) }

    describe 'for moderator object' do
      it 'returns name attribute correct' do
        moderator.name.must_equal 'Anton'
      end

      it 'returns role attribute correct' do
        moderator.role.must_equal 'moderator'
      end

      it 'returns rates attribute correct' do
        moderator.rates.must_equal [1, 2, 3]
      end

      it 'raises error for last_name attribute' do
        -> { moderator.last_name }.must_raise NoMethodError
      end
    end

    describe 'for admin object' do
      it 'returns name attribute correct' do
        admin.name.must_equal 'Anton'
      end

      it 'returns role attribute correct' do
        admin.role.must_equal 0
      end

      it 'raises error for rates attribute' do
        -> { admin.rates }.must_raise NoMethodError
      end

      it 'returns last_name attribute correct' do
        admin.last_name.must_equal 'New'
      end
    end
  end

  describe 'with inheritance from class that mixes in ShallowAttributes, but does not define attributes' do
    it 'returns email attribute correct' do
      search = Sub1.new(email: 'foo@bar.com')
      search.email.must_equal 'foo@bar.com'
    end
  end

  describe 'with inheritance from class that does not mixin ShallowAttributes' do
    it 'returns email attribute correct' do
      search = Sub2.new(email: 'foo@bar.com')
      search.email.must_equal 'foo@bar.com'
    end
  end
end
