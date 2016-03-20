require 'test_helper'

describe ShallowAttributes::Type::Time do
  let(:type) { ShallowAttributes::Type::Time.new }

  describe '#coerce' do
    describe 'when value is DateTime' do
      it 'returns time object' do
        time = DateTime.now
        type.coerce(time).class.must_equal Time
      end
    end

    describe 'when value is Time' do
      it 'returns time object' do
        time = Time.now
        type.coerce(time).must_equal time
      end
    end

    describe 'when value is String' do
      it 'returns time object' do
        type.coerce('Thu Nov 29 14:33:20 GMT 2001').to_s.must_equal '2001-11-29 14:33:20 +0000'
      end
    end

    describe 'when value is invalid String' do
      it 'returns error' do
        -> { type.coerce('') }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce('asd') }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce('123123') }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end

    describe 'when value is Numeric' do
      it 'returns time object' do
        type.coerce(628232400).to_s.must_equal '1989-11-28 08:00:00 +0300'
      end
    end

    describe 'when value is Nil' do
      it 'returns InvalidValueError' do
        -> { type.coerce(nil) }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end

    describe 'when value is TrueClass' do
      it 'returns InvalidValueError' do
        -> { type.coerce(true) }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end

    describe 'when value is FalseClass' do
      it 'returns InvalidValueError' do
        -> { type.coerce(false) }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end

    describe 'when value is not allowed' do
      it 'returns error' do
        -> { type.coerce([]) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce({}) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(:'1') }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end
  end
end
