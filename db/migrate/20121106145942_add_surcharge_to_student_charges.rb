class AddSurchargeToStudentCharges < ActiveRecord::Migration
  def change
    add_column :student_charges, :surcharge, :boolean
  end
end
