class AddPlanToStudents < ActiveRecord::Migration
  def change
    add_column :students, :plan_id, :integer
  end
end
