require 'test_helper'

describe ShallowAttributes::Type::String do
  let(:type) { ShallowAttributes::Type::String.new }

  describe '#coerce' do
    describe 'when value is String' do
      it 'returns string' do
        type.coerce('test').must_equal 'test'
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
  end
end
