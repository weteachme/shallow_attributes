require 'test_helper'

class User
  include ShallowAttributes

  attribute :name, String
  attribute :age, Integer
  attribute :birthday, DateTime
end

describe ShallowAttributes do
  let(:user) { User.new(name: 'Anton', age: 22) }

  describe 'on initialize' do
    let(:user) { User.new }

    it 'builds getter for attribute' do
      user.name.must_equal nil
      user.age.must_equal nil
    end

    it 'builds setter for attribute' do
      user.name = 'Anton'
      user.name.must_equal 'Anton'

      user.age = 22
      user.age.must_equal 22
    end

    it 'sets attributes from hash' do
      user = User.new(name: 'Anton', age: 22)

      user.name.must_equal 'Anton'
      user.age.must_equal 22
    end
  end

  describe '#attributes=' do
    it 'mass-assignments object attributes' do
      user.attributes = { name: 'Alex' }

      user.name.must_equal 'Alex'
      user.age.must_equal 22
    end
  end

  describe '#attributes' do
    it 'returns attributes like hash' do
      user.attributes.must_equal(name: 'Anton', age: 22)
    end
  end

  describe 'setters' do
    let(:user) { User.new(name: 'Anton', age: '22', birthday: 'Thu Nov 29 14:33:20 GMT 2001') }

    it 'converts value to specific type' do
      user.age.must_equal 22
      user.birthday.must_be_instance_of DateTime
      user.birthday.to_s.must_equal '2001-11-29T14:33:20+00:00'
    end
  end
end
