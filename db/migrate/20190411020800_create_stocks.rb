class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :companyName
      t.string :primaryExchange
      t.string :sector
      t.float :open
      t.float :close
      t.float :high
      t.float :low
      t.float :latestPrice
      t.datetime :latestTime
      t.integer :latestVolume
      t.float :iexRealTimePrice
      t.float :previousClose
      t.float :changePercent
      t.integer :iexVolume
      t.integer :avgTotalVolume
      t.float :iexBidPrice
      t.integer :iexBidSize
      t.float :iexAskPrice
      t.integer :iexAskSize
      t.integer :marketCap
      t.float :peRatio
      t.float :week52High
      t.float :week52Low
      t.float :ytdChange
      t.references :position, foreign_key: true

      t.timestamps
    end
  end
end
