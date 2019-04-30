require 'test_helper'

describe ShallowAttributes::Type::Date do
  let(:type) { ShallowAttributes::Type::Date.new }

  describe '#coerce' do
    describe 'when value is Date' do
      it 'returns date object' do
        date = Date.today
        type.coerce(date).class.must_equal Date
      end
    end

    describe 'when value is DateTime' do
      it 'returns time object' do
        time = DateTime.now
        type.coerce(time).must_equal time.to_date
      end
    end

    describe 'when value is Time' do
      it 'returns time object' do
        time = Time.now
        type.coerce(time).must_equal time.to_date
      end
    end

    describe 'when value is String' do
      it 'returns time object' do
        type.coerce('Thu Nov 29 2001').to_s.must_equal '2001-11-29'
      end
    end

    describe 'when value is invalid String' do
      it 'returns error' do
        err = -> { type.coerce('') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "" for type "Date")

        err = -> { type.coerce('asd') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "asd" for type "Date")

        err = -> { type.coerce('123123') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "123123" for type "Date")
      end
    end

    describe 'when value is Nil' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(nil) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "" for type "Date")
      end
    end

    describe 'when value is TrueClass' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(true) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "true" for type "Date")
      end
    end

    describe 'when value is FalseClass' do
      it 'returns InvalidValueError' do
        err = -> { type.coerce(false) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "false" for type "Date")
      end
    end

    describe 'when value is not allowed' do
      it 'returns error' do
        err = -> { type.coerce([]) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "[]" for type "Date")

        err = -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "{}" for type "Date")

        err = -> { type.coerce(:'1') }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "1" for type "Date")

        err = -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_equal %(Invalid value "Class" for type "Date")

        err = -> { type.coerce(Class.new) }.must_raise ShallowAttributes::Type::InvalidValueError
        err.message.must_match 'Invalid value "#<Class:'
        err.message.must_match '" for type "Date"'
      end
    end
  end
end
