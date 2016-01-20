require 'as_json_presentable/presenter'

module AsJsonPresentable

  class InvalidPresenterAction < Exception
  end

  def self.included(klass)
    klass.extend ClassMethods
  end

  # Attempts to delegate to the presenter class's `#as_json`
  # if it exists, and falls back to the parent class's
  # implementation if it does not.
  def as_json(options=nil)
    if options && options[:presenter_action] && json_presenter_class
      json_presenter_class.new(self).as_json(options)
    else
      super(options)
    end
  end

  # Returns the presenter class, or nil if
  # no presenter class exists
  def json_presenter_class
    self.class.json_presenter_class
  end

  module ClassMethods

    # Allows the user to explicitly set the presenter class
    # if the default naming convention isn't desired.
    def define_json_presenter_class(klass)
      @json_presenter_class = klass
    end

    # Returns the presenter class if it has been explicitly
    # set or can be implied through naming conventions, or
    # returns nil if no presenter class exists.
    #
    # By default, the presenter class is inferred to be
    # named after the model class, but with the suffix
    # of "Presenter".
    #
    # e.g. If you have a model class called `Foo`,
    # its presenter is assumed to be called `FooPresenter`
    #
    # Alternatively, the presenter class can be explicitly
    # defined with `::defined_json_presenter_class`
    def json_presenter_class
      return @json_presenter_class if defined?(@json_presenter_class)

      klass_name = "#{self.name}Presenter"
      @json_presenter_class = Module.const_get(klass_name) if Module.const_defined?(klass_name)
    end
  end

end
