class CreateBankStatements < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_statements do |t|
      t.integer :type_transaction
      t.decimal :value, precision: 10, scale: 2
      t.references :account, null: false, foreign_key: true
      t.references :transfer, index: true

      t.timestamps
    end
  end
end
