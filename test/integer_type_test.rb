require 'test_helper'

describe ShallowAttributes::Type::Integer do
  describe '#coerce' do
    let(:type) { ShallowAttributes::Type::Integer.new }

    describe 'when value is String' do
      it 'returns integer' do
        type.coerce('1').must_equal 1
        type.coerce('1.0').must_equal 1
      end
    end

    describe 'when value is Numeric' do
      it 'returns integer' do
        type.coerce(1).must_equal 1
        type.coerce(1.1).must_equal 1
      end
    end

    describe 'when value is Nil' do
      it 'returns integer' do
        type.coerce(nil).must_equal 0
      end
    end

    describe 'when value is TrueClass' do
      it 'returns integer' do
        type.coerce(true).must_equal 1
      end
    end

    describe 'when value is FalseClass' do
      it 'returns integer' do
        type.coerce(false).must_equal 0
      end
    end

    describe 'when value is not allowed' do
      it 'returns error' do
        -> { type.coerce([]) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(:'1') }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(Class.new) }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end
  end
end
