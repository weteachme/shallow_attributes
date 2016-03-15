require 'test_helper'
require 'active_model'

class Children
  include ShallowAttributes
  include ActiveModel::Dirty

  attribute :scream, String
end

describe ShallowAttributes do
  describe 'with AM dirty' do
    let(:user) { Children.new(scream: '') }

    it 'have changed? method' do
      user.changed?.must_equal false
      user.scream = 'hello world!'
      user.changed?.must_equal true
    end

    describe '#reset_attribute' do
      it 'resets attribut changes' do
        user.scream = 'hello world!'
        user.changed?.must_equal true

        user.reset_attribute(:scream)
        user.scream_changed?.must_equal false
      end
    end


    it 'have changes method' do
      user.scream = 'hello world!'
      user.changes.must_equal('scream' => ['', 'hello world!'])
    end
  end
end
