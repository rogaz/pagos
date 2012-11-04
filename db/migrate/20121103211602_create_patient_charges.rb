class CreatePatientCharges < ActiveRecord::Migration
  def change
    create_table :patient_charges do |t|
      t.integer :amount
      t.string :liquidated
      t.string :description
      t.datetime :date
      t.integer :patient_id

      t.timestamps
    end
  end
end
