require 'test_helper'

describe ShallowAttributes::Types::Integer do
  describe '#coerce' do
    describe 'when value is String' do
      it 'returns integer' do
        type = ShallowAttributes::Types::Integer.new
        type.coerce('1').must_equal 1
      end
    end

    describe 'when value is Numeric' do
      it 'returns integer' do
        type = ShallowAttributes::Types::Integer.new
        type.coerce(1).must_equal 1
        type.coerce(1.1).must_equal 1
      end
    end

    describe 'when value is Nil' do
      it 'returns integer' do
        type = ShallowAttributes::Types::Integer.new
        type.coerce(nil).must_equal 0
      end
    end

    describe 'when value is TrueClass' do
      it 'returns integer' do
        type = ShallowAttributes::Types::Integer.new
        type.coerce(true).must_equal 1
      end
    end

    describe 'when value is FalseClass' do
      it 'returns integer' do
        type = ShallowAttributes::Types::Integer.new
        type.coerce(false).must_equal 0
      end
    end
  end
end
