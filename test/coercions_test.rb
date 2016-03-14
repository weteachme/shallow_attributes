require 'test_helper'

class NoisyString
  def coerce(value)
    value.to_s.upcase
  end
end

class User
  include ShallowAttributes

  attribute :scream, NoisyString
end


describe ShallowAttributes do
  describe 'with custom attribute encapsulating configuration' do
    let(:user) { User.new(scream: 'hello world!') }

    it 'allow custom coercions' do
      user.scream.must_equal "HELLO WORLD!"
    end
  end
end
