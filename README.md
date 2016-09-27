# ShallowAttributes
[![Build Status](https://travis-ci.org/davydovanton/shallow_attributes.svg?branch=master)](https://travis-ci.org/davydovanton/shallow_attributes)
[![Code Climate](https://codeclimate.com/github/davydovanton/shallow_attributes/badges/gpa.svg)](https://codeclimate.com/github/davydovanton/shallow_attributes)
[![Coverage Status](https://coveralls.io/repos/github/davydovanton/shallow_attributes/badge.svg?branch=master)](https://coveralls.io/github/davydovanton/shallow_attributes?branch=master)
[![Inline docs](http://inch-ci.org/github/davydovanton/shallow_attributes.svg?branch=master)](http://inch-ci.org/github/davydovanton/shallow_attributes)

Simple and lightweight Virtus analog without any dependencies. [Documentation][doc-link].

## Motivation

There are already a lot of good and flexible gems which solve a similar problem, allowing attributes
to be defined with their types, for example: [virtus][virtus-link], [fast_attributes][fast-attributes-link]
or [attrio][attrio-link]. However, the disadvantage of these gems is performance or API. So, the goal
of `ShallowAttributes` is to provide a simple solution which is similar to the `Virtus` API, simple, fast,
understandable and extendable.

This is [the performance benchmark][performance-benchmark] of ShallowAttributes compared to virtus gems.

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
### Table of contents
* [Using ShallowAttributes with Classes](#using-shallowattributes-with-classes)
* [Default Values](#default-values)
* [Embedded Value](#embedded-value)
* [Custom Coercions](#custom-coercions)
* [Collection Member Coercions](#collection-member-coercions)
* [Note about Member Coercions](#important-note-about-member-coercions)
* [Overriding setters](#overriding-setters)
* [ActiveModel validation](#activemodel-validation)

### Using ShallowAttributes with Classes
You can create classes extended with Virtus and define attributes:

```ruby
class User
  include ShallowAttributes

  attribute :name, String
  attribute :age, Integer
  attribute :birthday, DateTime
end

class SuperUser < User
  include ShallowAttributes

  attribute :name, String
  attribute :age, Integer, allow_nil: true
  attribute :birthday, DateTime
end

user = User.new(name: 'Anton', age: 31)
user.name       # => "Anton"

user.age = '31' # => 31
user.age = nil  # => nil
user.age.class  # => Fixnum

user.birthday = 'November 18th, 1983' # => #<DateTime: 1983-11-18T00:00:00+00:00 (4891313/2,0/1,2299161)>

user.attributes # => { name: "Anton", age: 31, birthday: nil }

# mass-assignment
user.attributes = { name: 'Jane', age: 21 }
user.name       # => "Jane"
user.age        # => 21

super_user = SuperUser.new
user.age = nil  # => 0
```

### Default Values

``` ruby
class Page
  include ShallowAttributes

  attribute :title, String

  # default from a singleton value (integer in this case)
  attribute :views, Integer, default: 0

  # default from a singleton value (boolean in this case)
  attribute :published, 'Boolean', default: false

  # default from a callable object (proc in this case)
  attribute :slug, String, default: lambda { |page, attribute| page.title.downcase.gsub(' ', '-') }

  # default from a method name as symbol
  attribute :editor_title, String,  default: :default_editor_title

  def default_editor_title
    published ? title : "UNPUBLISHED: #{title}"
  end
end

page = Page.new(title: 'Virtus README')
page.slug         # => 'virtus-readme'
page.views        # => 0
page.published    # => false
page.editor_title # => "UNPUBLISHED: Virtus README"

page.views = 10
page.views                    # => 10
page.reset_attribute(:views)  # => 0
page.views                    # => 0
```

### Embedded Value

``` ruby
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

class User
  include ShallowAttributes

  attribute :name,    String
  attribute :address, Address
end

user = User.new(address: {
  street: 'Street 1/2',
  zipcode: '12345',
  city: {
    name: 'NYC'
  }
})

user.address.street    # => "Street 1/2"
user.address.city.name # => "NYC"
```

### Custom Coercions

``` ruby
require 'json'

class Json
  def coerce(value, options = {})
    value.is_a?(::Hash) ? value : JSON.parse(value)
  end
end

class User
  include ShallowAttributes

  attribute :info, Json, default: {}
end

user = User.new
user.info = '{"email":"john@domain.com"}' # => {"email"=>"john@domain.com"}
user.info.class                           # => Hash

# With a custom attribute encapsulating coercion-specific configuration
class NoisyString
  def coerce(value, options = {})
    value.to_s.upcase
  end
end

class User
  include ShallowAttributes

  attribute :scream, NoisyString
end

user = User.new(scream: 'hello world!')
user.scream # => "HELLO WORLD!"
```

### Collection Member Coercions

``` ruby
# Support "primitive" classes
class Book
  include ShallowAttributes

  attribute :page_numbers, Array, of: Integer
end

book = Book.new(:page_numbers => %w[1 2 3])
book.page_numbers # => [1, 2, 3]

# Support EmbeddedValues, too!
class Address
  include ShallowAttributes

  attribute :address,     String
  attribute :locality,    String
  attribute :region,      String
  attribute :postal_code, String
end

class PhoneNumber
  include ShallowAttributes

  attribute :number, String
end

class User
  include ShallowAttributes

  attribute :phone_numbers, Array, of: PhoneNumber
  attribute :addresses,     Array, of: Address
end

user = User.new(
  :phone_numbers => [
    { :number => '212-555-1212' },
    { :number => '919-444-3265' } ],
  :addresses => [
    { :address => '1234 Any St.', :locality => 'Anytown', :region => "DC", :postal_code => "21234" } ])

user.phone_numbers # => [#<PhoneNumber:0x007fdb2d3bef88 @number="212-555-1212">, #<PhoneNumber:0x007fdb2d3beb00 @number="919-444-3265">]
user.addresses     # => [#<Address:0x007fdb2d3be448 @address="1234 Any St.", @locality="Anytown", @region="DC", @postal_code="21234">]

user.attributes
# => {
# =>   :phone_numbers => [
# =>     { :number => '212-555-1212' },
# =>     { :number => '919-444-3265' }
# =>   ],
# =>   :addresses => [
# =>     {
# =>       :address => '1234 Any St.',
# =>       :locality => 'Anytown',
# =>       :region => "DC",
# =>       :postal_code => "21234"
# =>     }
# =>   ]
# => }
```

### IMPORTANT note about member coercions

ShallowAttributes performs coercions only when a value is being assigned. If you mutate the value later on using its own interfaces then coercion won't be triggered.

Here's an example:

``` ruby
class Book
  include ShallowAttributes
  attribute :title, String
end

class Library
  include ShallowAttributes
  attribute :books, Array, of: Book
end

library = Library.new

# This will coerce Hash to a Book instance
library.books = [ { :title => 'Introduction' } ]

# This WILL NOT COERCE the value because you mutate the books array with Array#<<
library.books << { :title => 'Another Introduction' }
```

### Overriding setters

``` ruby
class User
  include ShallowAttributes

  attribute :name, String

  alias_method :_name=, :name=
  def name=(new_name)
    custom_name = nil
    if new_name == "Godzilla"
      custom_name = "Can't tell"
    end

    self._name = custom_name || new_name
  end
end

user = User.new(name: "Frank")
user.name # => 'Frank'

user = User.new(name: "Godzilla")
user.name # => 'Can't tell'
```

### ActiveModel validation

``` ruby
require 'active_model'

class Children
  include ShallowAttributes
  include ActiveModel::Validations

  attribute :scream, String
  validates :scream, presence: true
end

user = User.new(scream: '')
user.valid? # => false
user.scream = 'hello world!'
user.valid? # => true
```

## Ruby version support

ShallowAttributes is [known to work correctly][travis-link] with the following rubies:

* 2.0.0
* 2.1.8
* 2.2.4
* 2.3.0
* jruby-head

Also we run rbx-2 buld too.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davydovanton/shallow_attributes.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


[doc-link]: http://www.rubydoc.info/github/davydovanton/shallow_attributes/master
[virtus-link]: https://github.com/solnic/virtus
[fast-attributes-link]: https://github.com/applift/fast_attributes
[attrio-link]: https://github.com/jetrockets/attrio
[performance-benchmark]: https://gist.github.com/davydovanton/d14b51ab63e3fab63ecb
[travis-link]: https://travis-ci.org/davydovanton/shallow_attributes
