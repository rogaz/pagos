class CreateStudentCharges < ActiveRecord::Migration
  def change
    create_table :student_charges do |t|
      t.integer :amount
      t.string :liquidated
      t.string :description
      t.datetime :date
      t.integer :student_id

      t.timestamps
    end
  end
end
