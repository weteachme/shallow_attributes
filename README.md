# ShallowAttributes


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shallow_attributes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shallow_attributes

## Examples

### Using ShallowAttributes with Classes
You can create classes extended with Virtus and define attributes:

```ruby
class User
  include ShallowAttributes

  attribute :name, String
  attribute :age, Integer
  attribute :birthday, DateTime
end

user = User.new(name: 'Anton', age: 31)
user.name # => "Anton"

user.age = '31' # => 31
user.age.class # => Fixnum

user.birthday = 'November 18th, 1983' # => #<DateTime: 1983-11-18T00:00:00+00:00 (4891313/2,0/1,2299161)>

user.attributes # => { name: "Anton", age: 31, birthday: nil }

# mass-assignment
user.attributes = { name: 'Jane', age: 21 }
user.name # => "Jane"
user.age  # => 21
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davydovanton/shallow_attributes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

