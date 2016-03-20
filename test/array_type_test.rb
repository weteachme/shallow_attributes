require 'test_helper'

describe ShallowAttributes::Type::Array do
  describe '#coerce' do
    let(:type) { ShallowAttributes::Type::Array.new }

    describe 'when value is not Array' do
      it 'returns InvalidValueError' do
        -> { type.coerce('test', of: Integer) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(123, of: Integer) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(true, of: Integer) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce({a: :b}, of: Integer) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(Class) }.must_raise ShallowAttributes::Type::InvalidValueError
        -> { type.coerce(Class.new) }.must_raise ShallowAttributes::Type::InvalidValueError
      end
    end

    describe 'when value is Array' do
      it 'returns array of specific type' do
        type.coerce([], of: Integer).must_equal []
        type.coerce(['1', '2'], of: Integer).must_equal [1, 2]
        type.coerce([true, false], of: Integer).must_equal [1, 0]
      end
    end
  end
end
