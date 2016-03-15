require 'test_helper'
require 'active_model'

class User
  include ShallowAttributes
  include ActiveModel::Validations

  attribute :scream, String
  validates :scream, presence: true
end


describe ShallowAttributes do
  describe 'with AM validation' do
    let(:user) { User.new(scream: '') }

    it 'have valid? method' do
      user.valid?.must_equal false
      user.scream = 'hello world!'
      user.valid?.must_equal true
    end
  end
end
