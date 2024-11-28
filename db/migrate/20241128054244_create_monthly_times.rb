class CreateMonthlyTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_times do |t|
      t.jsonb :date_close_price
      t.references :etf, null: false, foreign_key: true

      t.timestamps
    end
  end
end
