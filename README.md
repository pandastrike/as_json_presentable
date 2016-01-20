# AsJsonPresentable

This is a simple implementation of the presenter pattern for JSON presentation.
When included in a class, it causes the class to attempt to delegate calls to
`#as_json` to a presenter class.

# Usage

For any model you want to make presentable, include the `AsJsonPresentable` module:
```ruby
class Foo
  include AsJsonPresentable
end
```

**TIP:** For use with Rails and ActiveRecord, if all your models will be presentable,
consider including an initializer that includes `AsJsonPresentable` in
`ActiveRecord::Base`

e.g.
`config/initializers/active_record_as_json_presentable_patch.rb`:
```ruby
ActiveRecord::Base.include AsJsonPresentable
```

Including the `AsJsonPresentable` module attempts to use a presenter object
on calls to `#as_json` if it is passed the `:presenter_action` option.

e.g. `object.as_json(presenter_action: :some_action)

By default, the presenter class is inferred to be named after the model class,
but with the suffix of "Presenter".

e.g. If you have a model class called `Foo`,
its presenter is assumed to be called `FooPresenter`

To override this, you can pass in a klass with the `define_json_presenter_class`
class method.

e.g.
```ruby
class Foo
  include AsJsonPresentable
  define_json_presenter_class SomeOtherPresenter
end
```

If `#as_json` is called without the `:presenter_action` options,
this delegates to the original model class definition of `#as_json`

Your presenter class can technically be any PORO that responds to `#as_json`,
but there is a handy base class, `AsJsonPresentable::Presenter` that you
can extend.

In the base class implementation, `#as_json` looks for the `:presenter_action`
option and attempts to call the `#as_<presenter_action>_json`, or raises
`AsJsonPresentable::InvalidPresenterAction` if the method doesn't exist.

Here is a complete example:
```ruby
class MyObjectPresenter < AsJsonPresentable::Presenter

  def as_special_json(options=nil)
    { special: true }
  end
end
```

```ruby
class MyObject
  include AsJsonPresentable
end
```

```ruby
obj = MyObject.new
obj.as_json(presenter_action: :special)
# => { special: true }
```

# Contributing

 1. Fork it!
 2. Create your feature branch: git checkout -b my-new-feature
 3. Commit your changes: git commit -am 'Add some feature'
 4. Push to the branch: git push origin my-new-feature
 5. Submit a pull request :D

