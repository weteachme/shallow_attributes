require 'test_helper'

describe ShallowAttributes::Types::Time do
  let(:type) { ShallowAttributes::Types::Time.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns time object' do
        type.coerce('Thu Nov 29 14:33:20 GMT 2001').to_s.must_equal '2001-11-29 14:33:20 +0000'
      end
    end

    describe 'when value is Numeric' do
      it 'returns time object' do
        type.coerce(628232400).to_s.must_equal '1989-11-28 08:00:00 +0300'
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
