class Insured < ApplicationRecord
  enum :house_ownership_status, [:rented, :owned]

  validates :age, presence: true
  validates :dependents, presence: true
  validates :married, inclusion: [true, false]
  validates :base_risk, presence: true, numericality: {in: 0..3}
  validates :vehicle_year, numericality: {greater_than: 0, allow_nil: true}
end
