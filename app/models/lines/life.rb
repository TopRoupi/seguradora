class Lines::Life
  attr_reader :insured

  def initialize(insured)
    @insured = insured
  end

  def eligible?
    insured.age <= 60
  end
end
