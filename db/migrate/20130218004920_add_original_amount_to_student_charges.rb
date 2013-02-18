class AddOriginalAmountToStudentCharges < ActiveRecord::Migration
  def change
    add_column :student_charges, :original_amount, :integer
  end
end
