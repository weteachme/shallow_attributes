require 'test_helper'

class City
  include ShallowAttributes

  attribute :name, String
  attribute :size, Integer, default: 9000
end

class Address
  include ShallowAttributes

  attribute :street,  String
  attribute :zipcode, String, default: '111111'
  attribute :city,    City
end

class Person
  include ShallowAttributes

  attribute :name,      String
  attribute :address,   Address
  attribute :addresses, Array, of: Address
end

describe ShallowAttributes do
  describe 'with custom types' do
    it 'allow embedded values' do
      person = Person.new(address: {
        street: 'Street 1/2', city: {
          name: 'NYC'
        }
      })

      person.address.zipcode.must_equal "111111"
      person.address.street.must_equal "Street 1/2"
      person.address.city.size.must_equal 9000
      person.address.city.name.must_equal "NYC"
    end

    it 'allow array of embedded values' do
      person = Person.new(addresses: [
        {
          street: 'Street 1/2',
          city: {
            name: 'NYC'
          }
        },
        {
          street: 'Street 3/2',
          city: {
            name: 'Moscow'
          }
        }
      ])

      person.addresses.count.must_equal 2

      person.addresses[0].street.must_equal "Street 1/2"
      person.addresses[0].city.name.must_equal "NYC"

      person.addresses[1].street.must_equal "Street 3/2"
      person.addresses[1].city.name.must_equal "Moscow"
    end
  end
end
