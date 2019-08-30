require 'test_helper'

describe ShallowAttributes::Type::DateTime do
  let(:type) { ShallowAttributes::Type::DateTime.new }

  describe '#coerce' do
    describe 'when value is DateTime' do
      it 'returns date time object' do
        time = DateTime.now
        type.coerce(time).must_equal time
      end
    end

    describe 'when value is Time' do
      it 'returns date time object' do
        time = Time.now
        type.coerce(time).class.must_equal DateTime
      end
    end

    describe 'when value is String' do
      it 'returns date time object' do
        type.coerce('Thu Nov 29 14:33:20 GMT 2001').to_s.must_equal '2001-11-29T14:33:20+00:00'
      end
    end

    describe 'when value is invalid String' do
      it 'returns error' do
        err = -> { type.coerce('') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "" for type "DateTime")

        err = -> { type.coerce('1') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "1" for type "DateTime")
      end
    end

    describe 'when value is Numeric' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(123123123) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "123123123" for type "DateTime")
      end
    end

    describe 'when value is Nil' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(nil) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "" for type "DateTime")
      end
    end

    describe 'when strict is false' do
      it 'returns nil' do
        assert_nil type.coerce(nil, strict: false)
      end
    end

    describe 'when value is TrueClass' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(true) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "true" for type "DateTime")
      end
    end

    describe 'when value is FalseClass' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(false) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "false" for type "DateTime")
      end
    end

    describe 'when value is not allowed' do
      it 'returns error' do
        err = -> { type.coerce([]) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "[]" for type "DateTime")

        err = -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "{}" for type "DateTime")

        err = -> { type.coerce(:'1') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "1" for type "DateTime")

        err = -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "Class" for type "DateTime")

        err = -> { type.coerce(Class.new) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_match 'Invalid value "#<Class:'
        err.message.must_match '" for type "DateTime"'
      end
    end
  end
end
