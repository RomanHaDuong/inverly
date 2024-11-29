# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

Favorite.destroy_all
Contribution.destroy_all
Investment.destroy_all
# Dont want to destroy ETFs to save API calls
Etf.destroy_all
User.destroy_all

puts "Creating 10 users"

10.times do
  User.create(
    name: Faker::Name.first_name,
    email: Faker::Internet.email,
    password: "password",
    password_confirmation: "password"
  )
end

brian = User.create(
    name: "brian",
    email: "brian@me.com",
    password: "password",
    password_confirmation: "password"
  )
puts "10 users created"

puts "Creating 15 etfs"

file_path = Rails.root.join("db", "etf_data.json")
etf_data = JSON.parse(File.read(file_path))

etf_data.each do |etf_hash|
  etf = Etf.where(
    id: etf_hash["id"],
    name: etf_hash["name"],
    ticker_symbol: etf_hash["ticker_symbol"],
    category: etf_hash["category"],
    description: etf_hash["description"],
    historical_data: etf_hash["historical_data"],
    current_price: etf_hash["current_price"],
    average_return: etf_hash["average_return"],
    inception_date: etf_hash["inception_date"],
    created_at: etf_hash["created_at"],
    updated_at: etf_hash["updated_at"]
  ).first_or_create!

  etf_hash["monthly_times"].each do |mt_hash|
    etf.monthly_times.where(
      id: mt_hash["id"],
      date_close_price: mt_hash["date_close_price"],
      created_at: mt_hash["created_at"],
      updated_at: mt_hash["updated_at"],
      etf_id: mt_hash["etf_id"]
    ).first_or_create!
  end

  etf_hash["holdings"].each do |holding_hash|
    etf.holdings.where(
      id: holding_hash["id"],
      symbol: holding_hash["symbol"],
      description: holding_hash["description"],
      weight: holding_hash["weight"],
      created_at: holding_hash["created_at"],
      updated_at: holding_hash["updated_at"],
      etf_id: holding_hash["etf_id"]
    ).first_or_create!
  end
end

def create_monthly_times(etf)
  return if etf.monthly_times.any?

  p response = FetchEtfData.new(etf.ticker_symbol).call_monthly_series
  monthly_series = response['Monthly Time Series']
  if monthly_series
    dates = monthly_series.keys
    dates.each do |date|
      MonthlyTime.where(
        etf: etf,
        date_close_price: { date => monthly_series[date]['4. close'] },
      ).first_or_create!
    end
  else
    puts "API exceeded for #{etf.ticker_symbol}"
  end
end

def create_holdings(etf)
  return if etf.holdings.any?

  p response = FetchEtfData.new(etf.ticker_symbol).call_holdings
  holdings = response['holdings']
  if holdings
    top_holdings = holdings[0..9]
    top_holdings.each do |holding|
      Holding.where(
        etf: etf,
        symbol: holding['symbol'],
        description: holding['description'],
        weight: holding['weight']
      ).first_or_create!
    end
  else
    puts "API exceeded for #{etf.ticker_symbol}"
  end


etf = Etf.where(name: "SPDR S&P 500 ETF Trust", ticker_symbol: "SPY", description: "Tracks the performance of the S&P 500 Index, covering 500 of the largest U.S. companies.", category: "Large-Cap Blend").first_or_create!
etf.update(inception_date: "1993-01-22")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Invesco QQQ Trust", ticker_symbol: "QQQ", description: "Tracks the Nasdaq-100 Index, focusing on 100 of the largest non-financial companies listed on the Nasdaq Stock Market.", category: "Technology/ Growth").first_or_create!
etf.update(inception_date: "1999-03-10")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard S&P 500 ETF", ticker_symbol: "VOO", description: "Tracks the S&P 500 Index with low expense ratios and broad U.S. market exposure.", category: "Large-Cap Blend").first_or_create!
etf.update!(inception_date: "2010-09-07")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares Russell 2000 ETF", ticker_symbol: "IWM", description: "Tracks the Russell 2000 Index, which focuses on small-cap U.S. companies.", category: "Small-Cap").first_or_create!
etf.update(inception_date: "2000-05-20")
create_holdings(etf)
create_monthly_times(etf)
etf =Etf.where(name: "Vanguard Total Stock Market ETF", ticker_symbol: "VTI", description: "Covers the entire U.S. stock market, including large-, mid-, small-, and micro-cap stocks.", category: "Broad Market").first_or_create!
etf.update(inception_date: "2001-05-24")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares MSCI Emerging Markets ETF", ticker_symbol: "EEM", description: "Tracks stocks in emerging market countries, such as China, India, and Brazil.", category: "Emerging Markets").first_or_create!
etf.update(inception_date: "2003-04-07")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard FTSE Developed Markets ETF", ticker_symbol: "VEA", description: "Covers large- and mid-cap stocks in developed markets outside the U.S. and Canada.", category: "International").first_or_create!
etf.update(inception_date: "2007-07-20")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares Core US Aggregate Bond ETF", ticker_symbol: "AGG", description: "Tracks a broad index of U.S. investment-grade bonds, including Treasuries, corporate, and mortgage-backed securities.", category: "Fixed Income").first_or_create!
etf.update(inception_date: "2003-09-22")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "SPDR Gold Shares", ticker_symbol: "GLD", description: "Tracks the price of gold bullion, providing a way to invest in gold without holding physical assets.", category: "Commodity").first_or_create!
etf.update(inception_date: "2004-11-18")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard Dividend Appreciation ETF", ticker_symbol: "VIG", description: "Focuses on U.S. companies with a history of growing dividends, emphasizing quality and stability.", category: "Dividend/Value").first_or_create!
etf.update(inception_date: "2006-04-12")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "ProShares UltraPro QQQ", ticker_symbol: "TQQQ", description: "A leveraged ETF that seeks to provide 3x the daily performance of the Nasdaq-100 Index.", category: "Leveraged/Technology Growth").first_or_create!
etf.update(inception_date: "2010-02-09")
create_holdings(etf)
create_monthly_times(etf)

etf = Etf.where(name: "Shares ESG Aware MSCI USA ETF", ticker_symbol: "ESGU", description: "Tracks U.S. companies with strong environmental, social, and governance (ESG) practices.", category: "ESG").first_or_create!
etf.update(inception_date: "2016-12-01")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "iShares 20+ Year Treasury Bond ETF", ticker_symbol: "TLT", description: "Tracks long-term U.S. Treasury bonds with maturities of 20 years or more.", category: "Fixed Income").first_or_create!
etf.update(inception_date: "2002-07-22")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "ARK Innovation ETF", ticker_symbol: "ARKK", description: "Focuses on disruptive and innovative companies in sectors like technology, healthcare, and robotics.", category: "Thematic Growth").first_or_create!
etf.update(inception_date: "2014-10-31")
create_holdings(etf)
create_monthly_times(etf)
etf = Etf.where(name: "Vanguard Value ETF", ticker_symbol: "VTV", description: "Tracks the CRSP US Large Cap Value Index, focusing on U.S. large-cap value-oriented companies.", category: "Large-Cap Growth").first_or_create!
etf.update(inception_date: "2004-01-26")
create_holdings(etf)
create_monthly_times(etf)
# Etf.create(name: "", ticker_symbol: "", description: "", category: "")
EtfExportJob.perform_now

puts "#{Etf.count} etfs created"

puts "Creating 10 investments"

10.times do
  Investment.create(
    user_id: User.all.sample.id,
    etf_id: Etf.all.sample.id,
    name: Faker::Company.name,
    description: Faker::Company.catch_phrase,
    risk_level: ["low", "medium", "high"].sample
  )
end

invest = Investment.create(
  user: brian,
  etf_id: Etf.all.sample.id,
  name: "apple",
  description: Faker::Company.catch_phrase,
  risk_level: ["low", "medium", "high"].sample
)

number_of_months = 12 * 10 # 10 years simulation, 120 months.
number_of_months.times do |month_index|
  date = (Date.today + month_index.months).beginning_of_month # 2024-11-01, 2024-12-01, 2025-01-01, etc.
  Contribution.create(
    amount: 30000, # JPY
    date: date,
    investment: invest,
  )
end

puts "10 investments created"

puts "creating 10 favorites"

10.times do
  Favorite.create(
    user_id: User.all.sample.id,
    etf_id: Etf.all.sample.id
  )
end

puts "10 favorites created"

puts "seeded successfully"
