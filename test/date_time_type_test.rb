require 'test_helper'

describe ShallowAttributes::Types::DateTime do
  let(:type) { ShallowAttributes::Types::DateTime.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns time object' do
        type.coerce('Thu Nov 29 14:33:20 GMT 2001').to_s.must_equal '2001-11-29T14:33:20+00:00'
      end
    end

    describe 'when value is Numeric' do
      it 'returns InvalidValueError' do
        -> { type.coerce(false) }.must_raise ShallowAttributes::Types::InvalidValueError
      end
    end

    describe 'when value is Nil' do
      it 'returns InvalidValueError' do
        -> { type.coerce(nil) }.must_raise ShallowAttributes::Types::InvalidValueError
      end
    end

    describe 'when value is TrueClass' do
      it 'returns InvalidValueError' do
        -> { type.coerce(true) }.must_raise ShallowAttributes::Types::InvalidValueError
      end
    end

    describe 'when value is FalseClass' do
      it 'returns InvalidValueError' do
        -> { type.coerce(false) }.must_raise ShallowAttributes::Types::InvalidValueError
      end
    end
  end
end
