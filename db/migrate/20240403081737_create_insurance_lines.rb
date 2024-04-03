class CreateInsuranceLines < ActiveRecord::Migration[7.1]
  def change
    create_table :insurance_lines, id: :uuid do |t|
      t.references :risk_profile, null: false, foreign_key: true, type: :uuid
      t.integer :risk_level, null: false
      t.string :line, null: false

      t.timestamps
    end
  end
end
