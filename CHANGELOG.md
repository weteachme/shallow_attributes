# ShallowAttributes Changes
## HEAD

### 0.9.6 (2026-04-01)

- Fix `NoMethodError: undefined method 'coerce' for an instance of Object` on Ruby 3.3
- Fix incorrect class name in `type/object.rb` (was `Hash`, now `Object`)
- Add `::Object` to `DEFAULT_TYPE_OBJECTS` for proper type resolution
- Add fallback handler for unknown types in `type_instance`
