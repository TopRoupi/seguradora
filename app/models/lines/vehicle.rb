class Lines::Vehicle
  attr_reader :insured

  def initialize(insured)
    @insured = insured
  end

  def eligible?
    !insured.vehicle_year.nil?
  end
end
