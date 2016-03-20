require 'test_helper'

describe ShallowAttributes::Type::Boolean do
  let(:type) { ShallowAttributes::Type::Boolean.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns InvalidValueError' do
        -> { type.coerce('test') }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce('') }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end

    describe 'when value is Numeric' do
      it 'returns true for not zero' do
        type.coerce(1).must_equal true
        type.coerce(1.0).must_equal true
      end

      it 'returns false for zero' do
        type.coerce(0).must_equal false
        type.coerce(0.0).must_equal false
      end
    end

    describe 'when value is Nil' do
      it 'returns false' do
        type.coerce(nil).must_equal false
      end
    end

    describe 'when value is TrueClass' do
      it 'returns true' do
        type.coerce(true).must_equal true
      end
    end

    describe 'when value is FalseClass' do
      it 'returns false' do
        type.coerce(false).must_equal false
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
