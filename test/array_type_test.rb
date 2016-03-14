require 'test_helper'

describe ShallowAttributes::Types::Array do
  describe '#coerce' do
    describe 'when value is not Array' do
      let(:type) { ShallowAttributes::Types::Array.new }

      it 'returns InvalidValueError' do
        -> { type.coerce('test', Integer) }.must_raise ShallowAttributes::Types::InvalidValueError
        -> { type.coerce(123, Integer) }.must_raise ShallowAttributes::Types::InvalidValueError
        -> { type.coerce(true, Integer) }.must_raise ShallowAttributes::Types::InvalidValueError
        -> { type.coerce({a: :b}, Integer) }.must_raise ShallowAttributes::Types::InvalidValueError
      end
    end

    describe 'when value is Array' do
      let(:type) { ShallowAttributes::Types::Array.new }

      it 'returns array of specific type' do
        type.coerce(['1', '2'], Integer).must_equal [1, 2]
        type.coerce([true, false], Integer).must_equal [1, 0]
      end
    end
  end
end
