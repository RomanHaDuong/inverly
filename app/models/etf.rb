class Etf < ApplicationRecord
  has_many :investments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :holdings, dependent: :destroy
  has_many :monthly_times, dependent: :destroy

  def latest_monthly_time
    return nil if monthly_times.empty?

    monthly_times.order(id: :asc).first
  end

  def earliest_monthly_time
    return nil if monthly_times.empty?

    monthly_times.order(id: :asc).last
  end

  def latest_monthly_time_price
    return nil if monthly_times.empty?

    latest_monthly_time.date_close_price.to_a[0][1].to_f
  end

  def earliest_monthly_time_price
    return nil if monthly_times.empty?

    earliest_monthly_time.date_close_price.to_a[0][1].to_f
  end
end
