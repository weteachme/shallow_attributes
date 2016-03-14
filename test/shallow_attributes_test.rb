require 'test_helper'

class User
  include ShallowAttributes

  attribute :name, String, default: 'Ben'
  attribute :last_name, String, default: :default_last_name
  attribute :full_name, String, default: -> (user, attribute) { "#{user.name} #{user.last_name}" }
  attribute :age, Integer
  attribute :birthday, DateTime

  attribute :friends_count, Integer, default: 0
  attribute :sizes, Array, of: Integer

  def default_last_name
    'Affleck'
  end
end

describe ShallowAttributes do
  let(:user) { User.new(name: 'Anton', age: 22) }

  describe 'on initialize' do
    let(:user) { User.new }

    it 'builds getters for each attribute' do
      user.age.must_equal nil
      user.birthday.must_equal nil
      user.sizes.must_equal []
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

    it 'sets object as default value for each attribute' do
      user.name.must_equal 'Ben'
      user.friends_count.must_equal 0
    end

    it 'sets method name as default value for each attribute' do
      user.last_name.must_equal 'Affleck'
    end

    it 'sets lambda as default value for each attribute' do
      user.full_name.must_equal 'Ben Affleck'
    end

    describe 'with array type' do
      it 'initializes array of objects' do
        user = User.new(sizes: %w[1 2 3])
        user.sizes.must_equal [1, 2, 3]
      end

      it 'builds setter for array attribute' do
        user = User.new
        user.sizes = %w[1 2 3]

        user.sizes.must_equal [1, 2, 3]
      end
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

  describe '#reset_attribute' do
    it 'reserts attribute value attributes like hash' do
      user.reset_attribute(:name)
      user.name.must_equal 'Ben'
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
