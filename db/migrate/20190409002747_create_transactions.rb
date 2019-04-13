class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :shares
      t.string :ticker
      t.float :price
      t.float :cost
      t.string :status
      t.text :reason
      t.references :user, foreign_key: true
      t.references :position, foreign_key: true
      t.references :fund, foreign_key: true
      t.timestamps
    end
  end
end
