require 'test_helper'
require 'dry-types'

module Types
  include Dry::Types.module
end

class MainDryUser
  include ShallowAttributes

  attribute :name, Types::String
  attribute :age, Integer
  attribute :birthday, DateTime
end

describe ShallowAttributes do
  let(:user) { MainDryUser.new(name: 'Anton', age: 22) }

  describe '::attributes' do
    it 'returns class attributes array' do
      MainDryUser.attributes.must_equal(%i(name age birthday))
    end
  end

  describe 'on initialize' do
    let(:user) { MainDryUser.new }

    it 'builds getters for each attribute' do
      assert_nil user.age
      assert_nil user.birthday
    end

    it 'builds setter for attribute' do
      user.name = 'Anton'
      user.name.must_equal 'Anton'

      user.age = 22
      user.age.must_equal 22
    end

    it 'sets attributes from symbolized hash' do
      user = MainDryUser.new(name: 'Anton', age: 22)

      user.name.must_equal 'Anton'
      user.age.must_equal 22
    end

    it 'sets attributes from stringified hash' do
      user = MainDryUser.new('name' => 'Anton', 'age' => 22)

      user.name.must_equal 'Anton'
      user.age.must_equal 22
    end

    it 'does not mutate the argument' do
      params = {'name' => 'Anton', 'age' => 22}
      MainDryUser.new(params)
      params.must_equal({'name' => 'Anton', 'age' => 22})
    end
  end

  describe '#attributes=' do
    it 'mass-assigns attributes from symbolized hash' do
      user.attributes = { name: 'Alex' }

      user.name.must_equal 'Alex'
      user.age.must_equal 22
    end

    it 'mass-assigns attributes from stringified hash' do
      user.attributes = { 'name' => 'Alex' }

      user.name.must_equal 'Alex'
      user.age.must_equal 22
    end

    it 'mass-assigns uninitialized attributes from stringified hash' do
      user = MainDryUser.new
      user.age.must_be_nil

      user.attributes = {"age" => "21"}
      user.age.must_equal 21
    end
  end

  describe '#attributes' do
    it 'returns attributes like hash' do
      user.attributes.must_equal(name: 'Anton', age: 22)
    end

    describe 'when value is nil' do
      it 'returns attributes like hash' do
        user.name  = nil
        user.age   = nil
        user.attributes.must_equal(name: nil, age: nil)
      end
    end
  end

  describe 'setters' do
    let(:user) { MainDryUser.new(name: 'Anton', age: '22', birthday: 'Thu Nov 29 14:33:20 GMT 2001') }

    it 'converts value to specific type' do
      user.age.must_equal 22
      user.birthday.must_be_instance_of DateTime
      user.birthday.to_s.must_equal '2001-11-29T14:33:20+00:00'
    end
  end
end
