class CreateRiskProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :risk_profiles, id: :uuid do |t|
      t.references :insured, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
