module AsJsonPresentable
  # Base JSON presenter class
  class Presenter
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    # Looks for the option `:presenter_action`. If it exists,
    # looks for a method called `#as_<presenter_action>_json`
    # and delegates to that method.
    # If `:presenter_action` isn't in the options, or it
    # references a method that the presenter doesn't respond to,
    # falls back to the resource's `#as_json` implementation.
    #
    # e.g.
    #
    # `presenter.as_json(presenter_action: :index)`
    #
    # will delegate to
    #
    # `presenter.as_index_json`
    def as_json(options=nil)
      presenter_action = (options || {}).delete(:presenter_action)

      if presenter_action.nil?
        resource.as_json(options)
      elsif has_presenter_method?(presenter_action)
        send(presenter_method(presenter_action), options)
      else
        raise InvalidPresenterAction.new("Unable to present JSON using action '#{presenter_action}'")
      end
    end

     # return object errors
    def as_error_json(options=nil)
      { errors: resource.errors }
    end

  private

    def has_presenter_method?(presenter_action)
      respond_to?(presenter_method(presenter_action))
    end

    def presenter_method(presenter_action)
      "as_#{presenter_action}_json"
    end

  end
end
