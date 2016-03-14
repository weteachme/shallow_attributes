require 'test_helper'

class User
  include ShallowAttributes
  attribute :name, String
  attribute :age, Integer
end

describe ShallowAttributes do
  describe 'on initialize' do
    it 'builds getter for attribute' do
      test_object = User.new
      test_object.name.must_equal nil
      test_object.age.must_equal nil
    end

    it 'builds setter for attribute' do
      test_object = User.new

      test_object.name = 'Anton'
      test_object.name.must_equal 'Anton'

      test_object.age = 22
      test_object.age.must_equal 22
    end

    it 'sets attributes from hash' do
      test_object = User.new(name: 'Anton', age: 22)
      test_object.name.must_equal 'Anton'
      test_object.age.must_equal 22
    end
  end

  describe '#attributes=' do
    it 'mass-assignments object attributes' do
      test_object = User.new(name: 'Anton', age: 22)
      test_object.attributes = { name: 'Alex' }

      test_object.name.must_equal 'Alex'
      test_object.age.must_equal 22
    end
  end

  describe '#attributes=' do
    it 'returns attributes like hash' do
      test_object = User.new(name: 'Anton', age: 22)
      test_object.attributes.must_equal(name: 'Anton', age: 22)
    end
  end
end
