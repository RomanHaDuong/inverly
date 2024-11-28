class AddInceptionDateToEtfs < ActiveRecord::Migration[7.1]
  def change
    add_column :etfs, :inception_date, :date
  end
end
