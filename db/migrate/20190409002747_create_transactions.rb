class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :shares
      t.string :ticker
      t.float :price
      t.float :traderPrice
      t.float :cost
      t.string :priceType
      t.string :tradeType
      t.string :status
      t.string :sector
      t.text :reason
      t.text :traderInstruction
      t.references :user, foreign_key: true
      t.references :position, foreign_key: true
      t.references :fund, foreign_key: true
      t.timestamps
    end
  end
end
