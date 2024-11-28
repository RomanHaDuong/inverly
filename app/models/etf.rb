class Etf < ApplicationRecord
  has_many :investments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
end
