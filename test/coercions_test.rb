require 'test_helper'

class NoisyString
  def coerce(value)
    value.to_s.upcase
  end
end

class User
  include ShallowAttributes

  attribute :scream,  NoisyString
  attribute :screams, Array, of: NoisyString
end


describe ShallowAttributes do
  describe 'with custom attribute encapsulating configuration' do
    let(:user) { User.new(scream: 'hello world!') }

    it 'allow custom coercion' do
      user.scream.must_equal "HELLO WORLD!"
    end

    it 'allow array of custom coercion' do
      user.screams = %w[hello world!]
      user.screams.must_equal %w[HELLO WORLD!]
    end
  end
end
