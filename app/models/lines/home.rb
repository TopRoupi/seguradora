class Lines::Home
  attr_reader :insured

  def initialize(insured)
    @insured = insured
  end

  def eligible?
    !insured.house_ownership_status.nil?
  end
end
