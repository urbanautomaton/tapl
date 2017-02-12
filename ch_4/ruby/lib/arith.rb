StuckError = Class.new(StandardError)

class Term
  def value?
    false
  end

  def numeric_value?
    false
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
  def initialize(term)
    @term = term
  end

  def value?
    numeric_value?
  end

  def numeric_value?
    term.numeric_value?
  end

  def reduce
    self.class.new(term.reduce)
  end
end

class Pred < Term
  def initialize(term)
    @term = term
  end

  def reduce
    case
    when @term.is_a?(Zero) then term
    when @term.is_a?(Succ) && term.term.numeric_value? then term.term
    else Pred.new(term.reduce)
    end
  end
end

class IsZero < Term
  def initialize(term)
    @term = term
  end

  def reduce
    case
    when term.is_a?(Zero) then True.new
    when term.is_a?(Succ) && term.term.numeric_value? then False.new
    else IsZero.new(term.reduce)
    end
  end
end

class If < Term
  def initialize(test, consequent, alternate)
    @test, @consequent, @alternate = test, consequent, alternate
  end

  def reduce
    case @test
    when True then @consequent
    when False then @alternate
    else If.new(@test.reduce, @consequent, @alternate)
    end
  end
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
