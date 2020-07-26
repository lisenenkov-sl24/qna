class User < ApplicationRecord
  has_many :answers, foreign_key: :author_id, dependent: :restrict_with_error
  has_many :questions, foreign_key: :author_id, dependent: :restrict_with_error

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
