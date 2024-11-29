class CreateHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings do |t|
      t.string :symbol
      t.string :description
      t.float :weight
      t.references :etf, null: false, foreign_key: true

      t.timestamps
    end
  end
end
