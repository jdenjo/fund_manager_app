class CreateFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :funds do |t|
      t.string :name
      t.text :strategy
      t.float :AUM
      t.datetime :inception
      t.integer :pm_id
      t.timestamps
    end
  end
end
