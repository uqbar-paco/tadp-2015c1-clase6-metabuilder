module Action
  attr_accessor :condition

  def valid(instance)
    instance.instance_eval &condition
  end

  #def condition
end

class ConditionalMethod
  include Action

  def initialize name, condition, implementation
    @name = name
    @condition = condition
    @implementation = implementation
  end

  def apply(instance)
    if (valid(instance))
      instance.define_singleton_method @name, @implementation
    end
  end
end

class Validation
  include Action

  def initialize condition
    @condition = condition
  end

  def apply(instance)
    if (!valid(instance))
      raise ValidationError
    end
  end

end

class ValidationError < BuildError
end