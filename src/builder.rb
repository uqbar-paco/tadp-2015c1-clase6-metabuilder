class Builder

  attr_accessor :a_class, :properties, :actions

  def initialize a_class, properties, actions
    @a_class = a_class
    @actions = actions
    @properties = {}
    properties.each { |property| @properties[property] = nil }
  end

  def method_missing name, *args, &block
    if properties.key? name
      properties[name] = args[0]
    else
      raise BuildError
    end
  end

  def build
    instance = a_class.new
    properties.each { |setter_name, value|
      instance.send setter_name, value
    }

    actions.each { |action|
      action.apply(instance)
    }

    instance
  end

end

class BuildError < StandardError
end

