require 'test_helper'

describe ShallowAttributes::Type::Float do
  let(:type) { ShallowAttributes::Type::Float.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns float' do
        type.coerce('').must_equal 0.0
        type.coerce('1').must_equal 1.0
        type.coerce('1.1').must_equal 1.1
      end
    end

    describe 'when value is Numeric' do
      it 'returns float' do
        type.coerce(1).must_equal 1.0
        type.coerce(1.1).must_equal 1.1
      end
    end

    describe 'when value is Nil' do
      it 'returns nil' do
        type.coerce(nil).must_equal 0
      end
    end

    describe 'when allow_nil is true' do
      it 'returns float' do
        assert_nil type.coerce(nil, allow_nil: true)
      end
    end

    describe 'when value is TrueClass' do
      it 'returns float' do
        type.coerce(true).must_equal 1.0
      end
    end

    describe 'when value is FalseClass' do
      it 'returns float' do
        type.coerce(false).must_equal 0.0
      end
    end

    describe 'when value is not allowed' do
      it 'returns error' do
        err = -> { type.coerce([]) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "[]" for type "Float")

        err = -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "{}" for type "Float")

        err = -> { type.coerce(:'1') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "1" for type "Float")

        err = -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "Class" for type "Float")

        err = -> { type.coerce(Class.new) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_match 'Invalid value "#<Class:'
        err.message.must_match '" for type "Float"'
      end
    end
  end
end
