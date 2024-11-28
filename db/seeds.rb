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

puts "Creating 10 etfs"

10.times do
  Etf.create(
    name: Faker::Company.name,
    ticker_symbol: "MMS",
    description: Faker::Company.catch_phrase,
    current_price: rand(1..100),
    category: ["stocks", "bonds", "commodities"].sample,
    average_return: rand(1..100)
  )
end

puts "10 etfs created"

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

puts "Creating 10 contributions"

10.times do
  Contribution.create(
    amount: rand(1..100),
    date: Date.today,
    paid: [true, false].sample,
    investment_id: Investment.all.sample.id
  )
end

puts "10 contributions created"

puts "creating 10 favorites"

10.times do
  Favorite.create(
    user_id: User.all.sample.id,
    etf_id: Etf.all.sample.id
  )
end

puts "10 favorites created"

puts "seeded successfully"
