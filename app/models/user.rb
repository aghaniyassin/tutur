class User < ApplicationRecord
  authenticates_with_sorcery!

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :first_name, length: { minimum: 3 }
  validates :last_name, length: { minimum: 2 }

  has_many :cars
  has_many :rentals

  before_save { self.email = email.downcase }

  def cars_rentals
    Rental.joins(:car).where('cars.user_id = ?', self.id)
  end
end
