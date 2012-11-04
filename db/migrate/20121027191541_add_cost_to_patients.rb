class AddCostToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :cost, :integer
  end
end
