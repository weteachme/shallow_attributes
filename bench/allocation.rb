require 'memory_profiler'
require 'shallow_attributes'

hash = { addresses: [ { street: 'Street 1/2', city: { name: 'NYC' } }, { street: 'Street 3/2', city: { name: 'Moscow' } } ] }
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
report = MemoryProfiler.report { 1_000.times { Person.new(hash) } }

puts report.pretty_print

# allocated memory by gem
# -----------------------------------
#    6830520  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    6310752  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    5790752  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    5150752  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    4950752  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    4550752  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    4550520  shallow_attributes/lib
#
# allocated memory by gem
# -----------------------------------
#    4470752  shallow_attributes/lib
