require_relative 'builder'
require_relative 'actions'

class Metabuilder

  def initialize
    @actions = []
    @properties = []
  end

  def set_target_class(a_class)
    @a_class = a_class
  end

  def add_property(sym)
    @properties << "#{sym.to_s}=".to_sym
  end

  def build
    Builder.new(@a_class, @properties, @actions)
  end

  alias_method :target_class, :set_target_class
  alias_method :property, :add_property

  def self.config &block
    metabuilder = Metabuilder.new
    metabuilder.instance_eval &block
    metabuilder
  end

  def validate &block
    @actions << Validation.new(block)
  end

  def conditional_method name, condition, implementation
    @actions << ConditionalMethod.new(name, condition, implementation)
  end

end