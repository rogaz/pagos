class CreateStudentPayments < ActiveRecord::Migration
  def change
    create_table :student_payments do |t|
      t.integer :amount
      t.datetime :date
      t.integer :student_charge_id

      t.timestamps
    end
  end
end
