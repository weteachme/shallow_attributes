require 'test_helper'

describe ShallowAttributes::Types::Boolean do
  let(:type) { ShallowAttributes::Types::Boolean.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns InvalidValueError' do
        -> { type.coerce('test') }.must_raise ShallowAttributes::Types::InvalidValueError
        -> { type.coerce('') }.must_raise ShallowAttributes::Types::InvalidValueError
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
  end
end
