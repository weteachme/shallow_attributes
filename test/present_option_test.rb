require 'test_helper'

class Book
  include ShallowAttributes
  attribute :title, String, present: true
end

class CreditCard
  include ShallowAttributes
  attribute :number, Integer, present: true
  attribute :owner, String, present: true
end

class FridgeWithDefault
  include ShallowAttributes
  attribute :temperature, String, present: true, default: '+4C'
end

class UserWithPresentFalse
  include ShallowAttributes
  attribute :name, String, present: false
end

class TypeChecking
  include ShallowAttributes
  attribute :arr, Array, present: true
  attribute :datetime, DateTime, present: true
  attribute :float, Float, present: true
  attribute :time, Time, present: true
  attribute :bool, Boolean, present: true
end

describe 'when present option set to true' do
  describe 'for one attribute' do
    it 'raises error for missing attribute' do
      err = -> { Book.new }.must_raise ShallowAttributes::MissingAttributeError
      err.message.must_equal 'Mandatory attribute "title" was not provided'
    end

    it 'works fine for present attribute' do
      Book.new(title: 'The Stranger').title.must_equal 'The Stranger'
    end
  end

  describe 'for more than one attribute' do
    it 'raises error for the first attribute' do
      err = -> { CreditCard.new }.must_raise ShallowAttributes::MissingAttributeError
      err.message.must_equal 'Mandatory attribute "number" was not provided'
    end

    it 'works fine for present attributes' do
      CreditCard.new(number: 123, owner: 'Andrew').number.must_equal 123
    end
  end

  describe 'for an attribute with a default value' do
    # I don't know for what reason someone would set presence & default options
    # together, but just in case

    it 'sets missing attribute to default value' do
      FridgeWithDefault.new.temperature.must_equal '+4C'
    end
  end

  describe 'for various types' do
    let(:options) { Hash[datetime: DateTime.now, float: 0.10, time: DateTime.now, bool: true] }

    it 'sets default array value to [], so nothing is raised' do
      TypeChecking.new(options).arr.must_equal []
    end

    it 'raises error if DateTime is not present' do
      -> { TypeChecking.new(options.tap { |opts| opts.delete(:datetime) }) }
        .must_raise ShallowAttributes::MissingAttributeError
    end

    it 'raises error if Float is not present' do
      -> { TypeChecking.new(options.tap { |opts| opts.delete(:float) }) }
        .must_raise ShallowAttributes::MissingAttributeError
    end

    it 'raises error if Time is not present' do
      -> { TypeChecking.new(options.tap { |opts| opts.delete(:time) }) }
        .must_raise ShallowAttributes::MissingAttributeError
    end

    it 'raises error if Boolean is not present' do
      -> { TypeChecking.new(options.tap { |opts| opts.delete(:bool) }) }
        .must_raise ShallowAttributes::MissingAttributeError
    end
  end
end

describe 'with present option set to false' do
  # Again, I doubt that anyone would ever specify 'present: false', but just in case
  it 'does not raise error' do
    UserWithPresentFalse.new(name: 'Nikita').name.must_equal 'Nikita'
  end
end
