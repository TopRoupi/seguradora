require "test_helper"

class InsuredTest < ActiveSupport::TestCase
  setup do
    @insured = insureds(:base)
  end
  # validations
  test "validate age" do
    @insured.age = nil
    @insured.valid?
    refute_empty @insured.errors[:age]
    @insured.age = 0
    @insured.valid?
    assert_empty @insured.errors[:age]
    @insured.age = 20
    @insured.valid?
    assert_empty @insured.errors[:age]
  end

  test "validate dependents" do
    @insured.dependents = nil
    @insured.valid?
    refute_empty @insured.errors[:dependents]
    @insured.dependents = 20
    @insured.valid?
    assert_empty @insured.errors[:dependents]
  end

  test "validate house_ownership_status" do
    @insured.house_ownership_status = nil
    @insured.valid?
    assert_empty @insured.errors[:house_ownership_status]
    @insured.house_ownership_status = :rented
    @insured.valid?
    assert_empty @insured.errors[:house_ownership_status]
  end

  test "validate married" do
    @insured.married = nil
    @insured.valid?
    refute_empty @insured.errors[:married]
    @insured.married = true
    @insured.valid?
    assert_empty @insured.errors[:married]
    @insured.married = false
    @insured.valid?
    assert_empty @insured.errors[:married]
  end

  test "validate base_risk" do
    @insured.base_risk = nil
    @insured.valid?
    refute_empty @insured.errors[:base_risk]
    @insured.base_risk = 0
    @insured.valid?
    assert_empty @insured.errors[:base_risk]
    @insured.age = 3
    @insured.valid?
    assert_empty @insured.errors[:age]
    @insured.base_risk = 4
    @insured.valid?
    refute_empty @insured.errors[:base_risk]
    assert_empty @insured.errors[:age]
    @insured.base_risk = -1
    @insured.valid?
    refute_empty @insured.errors[:base_risk]
  end

  test "validate vehicle_year" do
    @insured.vehicle_year = nil
    @insured.valid?
    assert_empty @insured.errors[:vehicle_year]
    @insured.vehicle_year = -1
    @insured.valid?
    refute_empty @insured.errors[:vehicle_year]
  end
end
