class AddRateToBankStatement < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_statements, :rate, :decimal, precision: 10, scale: 2
  end
end
