class Builder

  def initialize a_class, properties, actions
    singleton_class.send :attr_accessor, *properties
    @a_class = a_class
    @properties = properties
    @actions = actions
  end

  def build
    instance = @a_class.new
    @properties.each { |property|
      value = self.send property
      instance.send "#{property}=", value
    }

    @actions.each { |action|
      action.apply(instance)
    }

    instance
  end

end

class ValidationError < StandardError
end

class Validation
  attr_accessor :validation

  def initialize validation
    @validation = validation
  end

  def valid instance
    instance.instance_eval &@validation
  end

  def apply(instance)
    if (!valid(instance))
      raise ValidationError
    end
  end
end

class ConditionMethod < Validation
  attr_accessor :name, :definition

  def initialize name, validation, definition
    super validation
    @name = name
    @definition = definition
  end

  def apply instance
    if (valid(instance))
      instance.define_singleton_method @name, &@definition
    end
  end
end

class Metabuilder
  attr_accessor :a_class, :properties

  def initialize
    @setters = []
    @actions = []
  end

  def set_target_class a_class
    @a_class = a_class
  end

  def add_property sym
    @setters << sym
  end

  def build
    Builder.new @a_class, @setters, @actions
  end

  def self.config &block
    metabuilder = self.new
    metabuilder.instance_eval &block
    metabuilder
  end

  alias_method :target_class, :set_target_class
  alias_method :property, :add_property

  def validate &block
    @actions << Validation.new(block)
  end

  def conditional_method sym, validation, definition
    @actions << ConditionMethod.new(sym, validation, definition)
  end

end












