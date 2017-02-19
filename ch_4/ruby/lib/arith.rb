StuckError = Class.new(StandardError)

class Term
  def value?
    false
  end

  def numeric_value?
    false
  end

  def to_s
    self.class.name
  end

  def reduce
    raise NotImplementedError
  end
end

class Value < Term
  def value?
    true
  end

  def reduce
    raise StuckError
  end
end

class NumericValue < Value
  def numeric_value?
    true
  end
end

True  = Class.new(Value)
False = Class.new(Value)
Zero  = Class.new(NumericValue)

class Succ < Term
  attr_reader :term

  def initialize(term)
    @term = term
  end

  def value?
    numeric_value?
  end

  def numeric_value?
    term.numeric_value?
  end

  def to_s
    "Succ(#{term})"
  end

  def reduce
    self.class.new(term.reduce)
  end
end

def Succ(term)
  Succ.new(term)
end

class Pred < Term
  attr_reader :term

  def initialize(term)
    @term = term
  end

  def to_s
    "Pred(#{term})"
  end

  def reduce
    case
    when term.is_a?(Zero) then term
    when term.is_a?(Succ) && term.term.numeric_value? then @term.term
    else Pred.new(term.reduce)
    end
  end
end

def Pred(term)
  Pred.new(term)
end

class IsZero < Term
  attr_reader :term

  def initialize(term)
    @term = term
  end

  def to_s
    "IsZero(#{term})"
  end

  def reduce
    case
    when term.is_a?(Zero) then True.new
    when term.is_a?(Succ) && term.term.numeric_value? then False.new
    else IsZero.new(term.reduce)
    end
  end
end

def IsZero(term)
  IsZero.new(term)
end

class If < Term
  attr_reader :test, :consequent, :alternate

  def initialize(test, consequent, alternate)
    @test, @consequent, @alternate = test, consequent, alternate
  end

  def to_s
    "If(#{test}, #{consequent}, #{alternate})"
  end

  def reduce
    case test
    when True then consequent
    when False then alternate
    else If.new(test.reduce, consequent, alternate)
    end
  end
end

def If(test, consequent, alternate)
  If.new(test, consequent, alternate)
end

class Machine
  def evaluate(term)
    if term.value?
      term
    else
      evaluate(term.reduce)
    end
  end
end

term = If(
    IsZero(Pred(Succ(Pred(Succ(Zero.new))))),
    Succ(Succ(Zero.new)),
    If(False.new, Zero.new, Succ(Zero.new))
  )

puts term
puts "=>"
puts Machine.new.evaluate(term)
