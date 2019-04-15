require 'test_helper'

describe ShallowAttributes::Type::String do
  let(:type) { ShallowAttributes::Type::String.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns string' do
        type.coerce('').must_equal ''
        type.coerce('test').must_equal 'test'
      end
    end

    describe 'when value is Symbol' do
      it 'returns string' do
        type.coerce(:test).must_equal 'test'
      end
    end

    describe 'when value is Numeric' do
      it 'returns string' do
        type.coerce(1).must_equal '1'
        type.coerce(1.1).must_equal '1.1'
      end
    end

    describe 'when value is Nil' do
      it 'returns empty string' do
        type.coerce(nil).must_equal ''
      end
    end

    describe 'when allow_nil is true' do
      it 'returns integer' do
        assert_nil type.coerce(nil, allow_nil: true)
      end
    end

    describe 'when value is TrueClass' do
      it 'returns string' do
        type.coerce(true).must_equal 'true'
      end
    end

    describe 'when value is FalseClass' do
      it 'returns string' do
        type.coerce(false).must_equal 'false'
      end
    end

    describe 'when value is Array' do
      it 'returns string' do
        type.coerce([]).must_equal ''
        type.coerce([1, 2, 'string']).must_equal '12string'
      end
    end

    describe 'when value is Hash' do
      it 'returns error' do
        err = -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "{}" for type "String")
      end
    end

    describe 'when value is Class' do
      it 'returns error' do
        err = -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "Class" for type "String")
      end
    end

    describe 'when value is custom object with #to_s' do
      class Test
        def to_s
          'hello'
        end
      end

      it 'returns error' do
        type.coerce(Test.new).must_equal 'hello'
      end
    end
  end
end
