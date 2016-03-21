require 'test_helper'

describe ShallowAttributes::Type::Boolean do
  let(:type) { ShallowAttributes::Type::Boolean.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce('test') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "test" for type "Boolean")

        err = -> { type.coerce('') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "" for type "Boolean")
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
        err = -> { type.coerce([]) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "[]" for type "Boolean")

        err = -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "{}" for type "Boolean")

        err = -> { type.coerce(:'1') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "1" for type "Boolean")

        err = -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "Class" for type "Boolean")

        err = -> { type.coerce(Class.new) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_match 'Invalid value "#<Class:'
        err.message.must_match '" for type "Boolean"'
      end
    end
  end
end
