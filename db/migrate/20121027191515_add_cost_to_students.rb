class AddCostToStudents < ActiveRecord::Migration
  def change
    add_column :students, :cost, :integer
  end
end
