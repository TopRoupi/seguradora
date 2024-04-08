class Lines::Disability
  attr_reader :insured

  def initialize(insured)
    @insured = insured
  end

  def eligible?
    insured.income > 0 && insured.age < 61
  end
end
