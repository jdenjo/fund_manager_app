class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :shares
      t.string :ticker
      t.float :price
      t.string :status
      t.text :reason
      t.references :position, foreign_key: true
      t.timestamps
    end
  end
end
