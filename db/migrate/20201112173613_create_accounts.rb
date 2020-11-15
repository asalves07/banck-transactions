class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number
      t.string :agency
      t.integer :type_account
      t.decimal :balance, precision: 10, scale: 2
      t.integer :state, default: 1
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
