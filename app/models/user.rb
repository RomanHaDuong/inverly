class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :investments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :contributions, through: :investments
end
