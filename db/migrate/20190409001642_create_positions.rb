class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.string :ticker
      t.datetime :termination
      t.references :user
      t.references :fund, foreign_key: true

      t.timestamps
    end
  end
end
