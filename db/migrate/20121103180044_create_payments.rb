class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.datetime :date
      t.integer :charge_id

      t.timestamps
    end
  end
end
